# terraform.tfvars
# This file contains the variable definitions for the Shared VPC Demo project.
# 
# Variables:
# - project_id: The ID of the GCP project.
# - billing_account_id: The billing account ID associated with the GCP project.
# - org_id: The organization ID for the GCP project.
# - service_project_1_name: The name of the first service project.
# - service_project_2_name: The name of the second service project.
# - region: The region where resources will be deployed.
# - zone: The zone within the specified region where resources will be deployed.
# - host_project_name: The name of the host project for the Shared VPC.
# - create_vm_1: Boolean flag to create the first VM instance.
project_id             = "<PROJECT_ID where you run it from>"
billing_account_id     = "<BILLING_ACCOUNT_ID>"
org_id                 = "<ORG_ID>"
service_project_1_name = "<SERVICE_PROJECT_1_NAME>"
service_project_2_name = "<SERVICE_PROJECT_2_NAME>"
region                 = "us-central1"
zone                   = "us-central1-c"
host_project_name      = "<HOST_PROJECT_NAME>"
create_vm_1            = true
create_vm_2            = true
subnet_1_name          = "sub01"
subnet_2_name          = "sub02"
subnet_1_cidr          = "10.0.1.0/24"
subnet_2_cidr          = "10.0.2.0/24"