terraform {
   backend "azurerm" {
    key                  = "Dev/First-remote-file.terraform.tfstate"
    resource_group_name  = "dev-tfstate-rg"
    storage_account_name = "devtfstatestgacc"
    container_name       = "devtfstatestgacc-cont"
  }
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }
}

provider "azurerm" {
  features {}
  
}

resource "azurerm_resource_group" "dev-d01-rg" {
  name     = "dev-d01-rg"
  location = "West Europe"
}

resource "azurerm_network_interface" "vmdevd01-nic01" {
  name                = "vmdevd01-nic01"
  location            = azurerm_resource_group.dev-d01-rg.location
  resource_group_name = azurerm_resource_group.dev-d01-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/subid/resourceGroups/test_RG01_tf/providers/Microsoft.Network/virtualNetworks/dev-vnet01-tf/subnets/dev-snet01-app-tf"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_linux_virtual_machine" "vmdevd01" {
  name                = "vmdevd01"
  resource_group_name = azurerm_resource_group.dev-d01-rg.name
  location            = azurerm_resource_group.dev-d01-rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "admin@user@123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vmdevd01-nic01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "SUSE"
    offer     = "sles-sap-15-sp3"
    sku       = "gen1"
    version   = "latest"
  }
}

