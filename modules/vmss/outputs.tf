# VMSS module outputs expose the scale set ID and name after deployment.
output "vmss_id" {
  description = "ID of the Virtual Machine Scale Set"
  value       = azurerm_windows_virtual_machine_scale_set.main.id
}

output "vmss_name" {
  description = "Name of the Virtual Machine Scale Set"
  value       = azurerm_windows_virtual_machine_scale_set.main.name
}
