output "frontdoor_id" {
  description = "ID of the Front Door"
  value       = azurerm_cdn_frontdoor_profile.main.id
}

output "frontdoor_endpoint" {
  description = "Hostname of the Front Door endpoint"
  value       = azurerm_cdn_frontdoor_endpoint.main.host_name
}
