# Networking module creates virtual network, subnets, and network security group.
# This module is responsible for the foundation of connectivity in Azure.
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-${var.environment}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet" "main" {
  # Create one subnet for each block provided in subnet_cidrs.
  count = length(var.subnet_cidrs)

  name                 = "${var.project_name}-${var.environment}-subnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_cidrs[count.index]]
}

resource "azurerm_network_security_group" "main" {
  # Attach a firewall policy to the subnet. Here we allow HTTP, HTTPS, and RDP.
  name                = "${var.project_name}-${var.environment}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowRDP"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "main" {
  count = length(azurerm_subnet.main)

  subnet_id                 = azurerm_subnet.main[count.index].id
  network_security_group_id = azurerm_network_security_group.main.id

  # Bind each subnet to the NSG so the security rules are enforced on subnet traffic.
}
