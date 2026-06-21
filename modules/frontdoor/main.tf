# Front Door module creates an Azure Front Door endpoint for global HTTP/HTTPS traffic.
resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "${var.project_name}-${var.environment}-fd"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "${var.project_name}-${var.environment}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

resource "azurerm_cdn_frontdoor_origin_group" "main" {
  name                     = "${var.project_name}-${var.environment}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled = false

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }

  health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Http"
    request_type        = "HEAD"
  }
}

resource "azurerm_cdn_frontdoor_origin" "main" {
  name                          = "${var.project_name}-${var.environment}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main.id
  enabled                       = true
  host_name                     = "example.com"
  http_port                     = 80
  https_port                    = 443
  origin_host_header            = "example.com"
  priority                      = 1
  weight                        = 50
}
