
terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  #create a resource group
  name     = "rgvm-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "main" {
  #create a virtual network
  name                = "vm-network"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = "rgvm-resources"
}

resource "azurerm_subnet" "internal" {
  #create a subnet
  name                 = "internal"
  resource_group_name  = "rgvm-resources"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  #create a network interface
  name                = "nicvm"
  location            = "East US"
  resource_group_name = "rg-vm"
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  #create the vm 
  name                  = "ubuntu-vm"
  location            = "East US"
  resource_group_name = "rg-vm"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B1ls"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "youradmin"
    admin_password = "yourpasswd"
    #attention you need to use a valide passwd, username and computername
  
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}