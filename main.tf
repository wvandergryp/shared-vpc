# Description: This Terraform configuration file creates a Shared VPC with two service projects and two VMs in each service project.
# Test by runing iperf3 between the VMs in the service projects.
# ssh to vm2 via gui and run iperf3 -s
# ssh to vm1 via gui and run iperf3 -c <vm2 internal ip> -t 60
# journalctl -u google-startup-scripts.service - to troublshoot if the startup script failed

# This Terraform configuration sets up the Google Cloud provider.
# It specifies the project ID and region to be used for the resources.
# The project ID and region are passed as variables (var.project_id and var.region).
provider "google" {
  project = var.project_id
  region  = var.region
}

# Generate a random suffix for project IDs
resource "random_id" "project_suffix" {
  byte_length = 4
}

# Define a local value `host_project_id` that concatenates the `host_project_name` variable 
# with a randomly generated hexadecimal suffix from `random_id.project_suffix`.
locals {
  host_project_id = "${var.host_project_name}-${random_id.project_suffix.hex}"
}

# Create the host project
resource "google_project" "host_project" {
  name       = var.host_project_name
  project_id = local.host_project_id
  org_id     = var.org_id
  billing_account = var.billing_account_id
  deletion_policy = "DELETE" # Change this from PREVENT to DELETE
}

# Enable Compute Engine API for the host project
resource "google_project_service" "host_compute" {
  project = google_project.host_project.project_id
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

# Create service project 1
resource "google_project" "service_project_1" {
  name       = var.service_project_1_name
  project_id = "${var.service_project_1_name}-${random_id.project_suffix.hex}"
  org_id     = var.org_id
  billing_account = var.billing_account_id
  deletion_policy = "DELETE" # Change this from PREVENT to DELETE
}

# Enable Compute Engine API for the host project
resource "google_project_service" "servproj1_compute" {
  project = google_project.service_project_1.project_id
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

# Create service project 2
resource "google_project" "service_project_2" {
  name       = var.service_project_2_name
  project_id = "${var.service_project_2_name}-${random_id.project_suffix.hex}"
  org_id     = var.org_id
  billing_account = var.billing_account_id
  deletion_policy = "DELETE" # Change this from PREVENT to DELETE
}

# Enable Compute Engine API for the host project
resource "google_project_service" "servproj2_compute" {
  project = google_project.service_project_2.project_id
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

# Create a Shared VPC in the host project
resource "google_compute_network" "shared_vpc" {
  name                    = "hostvp"
  auto_create_subnetworks = false
  project                 = google_project.host_project.project_id
  depends_on = [ google_project_service.host_compute ]
}

# Enable Shared VPC for the host project
resource "google_compute_shared_vpc_host_project" "host" {
  project = google_project.host_project.project_id
  depends_on = [ google_project_service.host_compute ]
}

# Create Subnet 1 for Service Project 1
resource "google_compute_subnetwork" "subnet_1" {
  name          = var.subnet_1_name
  ip_cidr_range = var.subnet_1_cidr
  region        = var.region
  network       = google_compute_network.shared_vpc.id
  project       = google_project.host_project.project_id
}

# Create Subnet 2 for Service Project 2
resource "google_compute_subnetwork" "subnet_2" {
  name          = var.subnet_2_name
  ip_cidr_range = var.subnet_2_cidr
  region        = var.region
  network       = google_compute_network.shared_vpc.id
  project       = google_project.host_project.project_id
}

# Grant Service Project 1 access to the Shared VPC
resource "google_compute_shared_vpc_service_project" "service_project_1" {
  host_project    = google_project.host_project.project_id
  service_project = google_project.service_project_1.project_id
  depends_on = [ google_compute_shared_vpc_host_project.host ]
}

# Grant Service Project 2 access to the Shared VPC
resource "google_compute_shared_vpc_service_project" "service_project_2" {
  host_project    = google_project.host_project.project_id
  service_project = google_project.service_project_2.project_id
  depends_on = [ google_compute_shared_vpc_host_project.host ]
}

# VM in Service Project 1
resource "google_compute_instance" "vm_1" {
  count        = var.create_vm_1 ? 1 : 0
  project      = google_project.service_project_1.project_id
  name         = "vm-1"
  machine_type = "f1-micro"
  zone         = var.zone

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y iperf3
  EOT

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_1.id
    # Removed access_config to ensure no external IP
    access_config {} 
  }
  depends_on = [ google_compute_shared_vpc_host_project.host ]
}

# VM in Service Project 2
resource "google_compute_instance" "vm_2" {
  count        = var.create_vm_2 ? 1 : 0
  project      = google_project.service_project_2.project_id
  name         = "vm-2"
  machine_type = "f1-micro"
  zone         = var.zone

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y iperf3
  EOT

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_2.id
    # Removed access_config to ensure no external IP
    access_config {} 
  }
  depends_on = [ google_compute_shared_vpc_host_project.host ]
}

# Firewall rule to allow internal traffic between VMs
resource "google_compute_firewall" "allow_internal_1" {
  name    = "allow-internal-1"
  network = google_compute_network.shared_vpc.self_link
  project = google_project.host_project.project_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "5201"]
  }

  source_ranges = [var.subnet_1_cidr, var.subnet_2_cidr]
  depends_on = [google_compute_network.shared_vpc]
}

# Create a firewall rule to allow SSH access via IAP
resource "google_compute_firewall" "allow-iap-ssh-ingress" {
  name      = "allow-iap-ssh-ingress"
  network   = google_compute_network.shared_vpc.self_link
  project = google_project.host_project.project_id
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  depends_on = [google_compute_network.shared_vpc]
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}