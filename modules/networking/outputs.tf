output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  description = "IDs of all subnets"
  value       = azurerm_subnet.main[*].id
}

output "subnet_names" {
  description = "Names of all subnets"
  value       = azurerm_subnet.main[*].name
}

output "nsg_id" {
  description = "ID of the Network Security Group"
  value       = azurerm_network_security_group.main.id
}
