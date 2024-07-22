terraform {
	required_providers {
		azurerm = {
		source = "hashicorp/azurerm"
		version = "=2.46.1"
		}
	}
}

provider "azurerm" {
  features {}
  subscription_id = "2188c431-61c4-4ae6-8f82-e69b11df6365"
  #client_id  	  = "miguel.acuna976@comunidadunir.net"
  #client_secret   = "Inetum20247_!_"
  tenant_id   	  = "899789dc-202f-44b4-8472-a6d40f9eb440"
}

resource "azurerm_resource_group" "rg" {
  name     = "kubernetes_rg"
  location = var.location
  
  tags = {
  	environment = "CP2"
  	}
}

resource "azurerm_storage_account" "stAccount" {
  name 			   = "staccountcp2"
  resource_group_name 	   = azurerm_resource_group.rg.name
  location  		   = azurerm_resource_group.rg.location
  account_tier 	      	   = "Standard"
  account_replication_type = "LRS"
  
  tags = {
  	environment = "CP2"
  	}
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
  	environment = "CP2"
  	}
}

resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address     	  = "10.0.1.10"
    public_ip_address_id 	  = azurerm_public_ip.myPublicIp1.id
  }
  tags = {
  	environment = "CP2"
  	}
}

resource "azurerm_public_ip" "myPublicIp1" {
  name                = "vmip1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku 		      = "Basic"
  
  tags = {
	environment = "CP2"
  	}
}


resource "azurerm_network_security_group" "mySecGroup" {
  name                = "sshtraffic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "CP2"
  }
}

resource "azurerm_network_interface_security_group_association" "mySecGroupAssociation1" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.mySecGroup.id
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "myVMLinux"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size 			= var.vm_size
  admin_username 	= "miguel"
  network_interface_ids = [azurerm_network_interface.nic.id]
  disable_password_authentication = true
	
 admin_ssh_key {
    username              = "miguel"
    public_key            = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  plan {
    name              = "centos-8-stream-free"
    product           = "centos-8-stream-free"
    publisher         = "cognosys"
  }
  source_image_reference {
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "LATEST"
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
  }
  tags = {
    environment = "CP2"
  }

  
}
