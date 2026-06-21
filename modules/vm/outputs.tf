output "vm_ids" {
  description = "IDs of all created VMs"
  value       = azurerm_windows_virtual_machine.main[*].id
}

output "vm_private_ips" {
  description = "Private IP addresses of VMs"
  value       = azurerm_network_interface.main[*].private_ip_address
}

output "vm_names" {
  description = "Names of all created VMs"
  value       = azurerm_windows_virtual_machine.main[*].name
}
