resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_input.name
  location            = var.vnet_input.location
  resource_group_name = var.vnet_input.rgrp 
  address_space       = [var.vnet_input.address_space] 
}

resource "azurerm_subnet" "subnet" {
for_each = var.subnet_input
  name                 = each.key
  resource_group_name  = each.value.rgrp
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.cidr]
}

