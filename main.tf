# Root configuration that ties together all module deployments.
# This file creates the shared resource group and then invokes modules.
resource "azurerm_resource_group" "main" {
  # A single Azure Resource Group is used as a container for all resources.
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

  # Ensure network resources exist before other dependent modules deploy.
  depends_on = [azurerm_resource_group.main]
}

# VM Module
# Builds one or more standalone Windows VMs inside the first subnet.
# It depends on the networking module because the VMs need a subnet.
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
# Deploys a Virtual Machine Scale Set for scalable compute workloads.
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
# Creates an Azure Storage Account and a private blob container.
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
# Creates an Azure Front Door endpoint to route traffic to backend VMs.
module "frontdoor" {
  source = "./modules/frontdoor"

  resource_group_name = azurerm_resource_group.main.name
  environment         = var.environment
  project_name        = var.project_name

  backend_vm_ids = module.vm.vm_ids

  tags = local.common_tags

  depends_on = [module.vm]
}
