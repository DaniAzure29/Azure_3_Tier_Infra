
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

resource "azurerm_key_vault" "projectvault122334355" {
  name                       = "projectvault23445543"
  location                   = azurerm_resource_group.projectgrp.location
  resource_group_name        = azurerm_resource_group.projectgrp.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = var.vmpassword.value
  key_vault_id = azurerm_key_vault.projectvault122334355.id
}