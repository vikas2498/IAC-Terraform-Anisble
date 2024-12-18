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

resource "azurerm_resource_group" "RG"{
name = "test_RG01_tf"
location = "West Europe"
}

resource "azurerm_virtual_network" "vnet-dev"{
name = "dev-vnet01-tf"
resource_group_name = azurerm_resource_group.RG.name
location = azurerm_resource_group.RG.location
address_space = ["10.0.0.0/21"]
}

resource "azurerm_subnet" "snet-dev-app" {
name = "dev-snet01-app-tf"
resource_group_name=azurerm_resource_group.RG.name
virtual_network_name= azurerm_virtual_network.vnet-dev.name
address_prefixes= ["10.0.1.0/24"]
}

resource "azurerm_subnet" "snet-dev-db" {
name = "dev-snet01-db-tf"
resource_group_name=azurerm_resource_group.RG.name
virtual_network_name= azurerm_virtual_network.vnet-dev.name
address_prefixes= ["10.0.2.0/24"]
}

resource "azurerm_resource_group" "dev-stg-rg-tf" {
  name     = "dev-tfstate-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "dev-stg-acc-tf" {
  name                     = "devtfstatestgacc"
  resource_group_name      = azurerm_resource_group.dev-stg-rg-tf.name
  location                 = azurerm_resource_group.dev-stg-rg-tf.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "devtfstatestgacc_cont" {
  name                  = "devtfstatestgacc-cont"
  storage_account_name  = azurerm_storage_account.dev-stg-acc-tf.name
  container_access_type = "private"
}
