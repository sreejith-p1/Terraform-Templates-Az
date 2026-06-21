# Storage module creates a storage account and a private blob container.
# Storage accounts must have a globally unique name, so we remove hyphens for validity.
resource "azurerm_storage_account" "main" {
  name                     = replace("${var.project_name}${var.environment}storage", "-", "")
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication_type

  https_traffic_only_enabled = true

  tags = var.tags
}

resource "azurerm_storage_container" "main" {
  name                  = "${var.project_name}-${var.environment}-container"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
