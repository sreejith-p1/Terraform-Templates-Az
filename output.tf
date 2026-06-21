# Networking Outputs
output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.networking.vnet_id
}

output "subnet_ids" {
  description = "IDs of the subnets"
  value       = module.networking.subnet_ids
}

# VM Outputs
output "vm_ids" {
  description = "IDs of the created VMs"
  value       = module.vm.vm_ids
}

output "vm_private_ips" {
  description = "Private IP addresses of VMs"
  value       = module.vm.vm_private_ips
}

# VMSS Outputs
output "vmss_id" {
  description = "ID of the Virtual Machine Scale Set"
  value       = module.vmss.vmss_id
}

# Storage Outputs
output "storage_account_id" {
  description = "ID of the Storage Account"
  value       = module.storage.storage_account_id
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of Storage Account"
  value       = module.storage.primary_blob_endpoint
}

# Frontend Outputs
output "frontdoor_endpoint" {
  description = "Hostname of the Front Door"
  value       = module.frontdoor.frontdoor_endpoint
}

# Resource Group
output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = azurerm_resource_group.main.name
}
