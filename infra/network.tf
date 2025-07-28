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

resource "azurerm_network_security_rule" "nsg_rules" {
   for_each = {
    for subnet_key, subnet in var.subnet_nsg_config:
      for rule in subnet.nsg_rules:
       "${subnet_key}-${rule.name}": {
        nsg_name = subnet.nsg_name
        rule = rule
       }

  }

  name                        = each.value.rule.name
  priority                    = each.value.rule.priority
  direction                   = each.value.rule.direction
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  resource_group_name         = azurerm_resource_group.projectgrp.name
  network_security_group_name = each.value.nsg_name
}

resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = var.subnet_nsg_config
  subnet_id                 = azurerm_subnet.infra_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}