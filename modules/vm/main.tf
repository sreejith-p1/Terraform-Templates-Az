# VM module deploys one or more Windows VMs with network interfaces.
resource "azurerm_network_interface" "main" {
  count = var.vm_count

  name                = "${var.project_name}-${var.environment}-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "main" {
  count = var.vm_count

  name                = "${var.project_name}-${var.environment}-vm-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size

  admin_username = "azureuser"
  admin_password = random_password.vm_password.result

  network_interface_ids = [azurerm_network_interface.main[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = var.tags
}

resource "random_password" "vm_password" {
  length  = 16
  special = true
}
