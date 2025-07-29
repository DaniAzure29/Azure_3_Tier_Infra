
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
