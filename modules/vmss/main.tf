resource "azurerm_windows_virtual_machine_scale_set" "main" {
  name                = "${var.project_name}-${var.environment}-vmss"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.vm_size
  instances           = var.instance_count

  admin_username = "azureuser"
  admin_password = random_password.vmss_password.result

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  network_interface {
    name                      = "${var.project_name}-${var.environment}-nic"
    primary                   = true
    network_security_group_id = null

    ip_configuration {
      name      = "internal"
      subnet_id = var.subnet_id
      primary   = true
    }
  }

  tags = var.tags
}

resource "random_password" "vmss_password" {
  length  = 16
  special = true
}
