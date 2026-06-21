resource "azurerm_resource_group" "main" {
  name     = "rg-${local.resource_prefix}"
  location = var.location

  tags = local.common_tags
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name

  tags = local.common_tags

  depends_on = [azurerm_resource_group.main]
}

# VM Module
module "vm" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name

  vm_count = var.vm_count
  vm_size  = var.vm_size

  subnet_id = module.networking.subnet_ids[0]

  tags = local.common_tags

  depends_on = [module.networking]
}

# VMSS Module
module "vmss" {
  source = "./modules/vmss"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name

  instance_count = var.vmss_instance_count
  vm_size        = var.vm_size

  subnet_id = module.networking.subnet_ids[1]

  tags = local.common_tags

  depends_on = [module.networking]
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name

  tags = local.common_tags

  depends_on = [azurerm_resource_group.main]
}

# Front Door Module
module "frontdoor" {
  source = "./modules/frontdoor"

  resource_group_name = azurerm_resource_group.main.name
  environment         = var.environment
  project_name        = var.project_name

  backend_vm_ids = module.vm.vm_ids

  tags = local.common_tags

  depends_on = [module.vm]
}
