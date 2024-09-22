# The ID of the controller project. Set this to your GCP project ID.
variable "project_id" {
  description = "The ID of the controller project"
  default     = "<PROJECT_ID>"
}

# A suffix to append to project names. Set this to any string you want to use as a suffix.
variable "project_suffix" {
  description = "A suffix to append to project names"
  default     = "hex"
}

# Boolean to decide whether to create the first VM. Set this to true or false.
variable "create_vm_1" {
  description = "Create the first VM"
  default     = false
}

# Boolean to decide whether to create the second VM. Set this to true or false.
variable "create_vm_2" {
  description = "Create the second VM"
  default     = false
}

# The name of the host project. Set this to your host project's name.
variable "host_project_name" {
  description = "The name of the host project"
  default = "<HOST_PROJECT_NAME>"
}

# The ID of the first service project. Set this to your first service project's ID.
variable "service_project_1_name" {
  description = "The ID of the first service project"
  default = "<SERVICE_PROJECT_1_NAME>"
}

# The ID of the second service project. Set this to your second service project's ID.
variable "service_project_2_name" {
  description = "The ID of the second service project"
  default = "<SERVICE_PROJECT_2_NAME>"
}

# Billing account ID. Set this to your GCP billing account ID.
variable "billing_account_id" {
  description = "Billing account ID"
  default = "<BILLING_ACCOUNT_ID>"
}

# Organization ID. Set this to your GCP organization ID.
variable "org_id" {
  description = "Organization ID"
  default = "<ORG_ID>"
}

# Region for the subnets. Set this to the desired GCP region.
variable "region" {
  description = "Region for the subnets"
  default     = "us-central1"
}

# Zone for the VMs. Set this to the desired GCP zone.
variable "zone" {
  description = "Zone for the VMs"
  default     = "us-central1-c"
}

variable "subnet_1_name" {
  description = "The name of the first subnet"
  default     = "subnet-1"
}

variable "subnet_2_name" {
  description = "The name of the second subnet"
  default     = "subnet-2"  
}

variable "subnet_1_cidr" {
  description = "The CIDR range for the first subnet"
  default     = "sub01"
}

variable "subnet_2_cidr" {
  description = "The CIDR range for the second subnet"
  default     = "sub02"
}