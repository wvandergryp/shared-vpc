
# Outputs the internal IP address of VM 1 if it is created.
# - vm_1_internal_ip: The internal IP address of the first VM instance.
#   - value: The internal IP address of VM 1 or null if VM 1 is not created.
output "vm_1_internal_ip" {
  value = var.create_vm_1 ? google_compute_instance.vm_1[0].network_interface[0].network_ip : null
}

# Outputs the internal IP address of VM 2 if it is created.
# - vm_2_internal_ip: The internal IP address of the second VM instance.
#   - value: The internal IP address of VM 2 or null if VM 2 is not created.
output "vm_2_internal_ip" {
  value = var.create_vm_2 ? google_compute_instance.vm_2[0].network_interface[0].network_ip : null
}