
resource "azurerm_network_security_rule" "nsg_rules" {
   for_each = {
        for rule in local.subnet_rules : rule.key => rule


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

