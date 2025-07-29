resource "azurerm_subnet" "bastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.projectgrp.name
  virtual_network_name = azurerm_virtual_network.infra_network.name
  address_prefixes     = [var.bastion_config.subnet_address]
}

resource "azurerm_public_ip" "bastionIp" {
  name                = "bastion_ip"
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastionhost" {
  name                = "bastionhost"
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name

  ip_configuration {
    name                 = "bastionconfig"
    subnet_id            = azurerm_subnet.bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastionIp.id
  }
}

