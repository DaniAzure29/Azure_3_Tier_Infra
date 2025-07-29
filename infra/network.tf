resource "azurerm_virtual_network" "infra_network" {
  name                = var.virtual_network_information.vnet_name
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name
  address_space       = var.virtual_network_information.address_space
}

resource "azurerm_subnet" "infra_subnets" {
    for_each = var.virtual_network_information.subnet_information
  name                 = each.key
  resource_group_name  = azurerm_resource_group.projectgrp.name
  virtual_network_name = azurerm_virtual_network.infra_network.name
  address_prefixes     = [each.value.cidrblock]
}

resource "azurerm_network_security_group" "nsgs" {
    for_each = var.subnet_nsg_config
  name                = each.value.nsg_name
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = var.subnet_nsg_config
  subnet_id                 = azurerm_subnet.infra_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}

