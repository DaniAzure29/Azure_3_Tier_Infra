resource "azurerm_storage_account" "example" {
  name                     = var.storage_inputs.name
  resource_group_name      = var.rgrp_name
  location                 = var.rgrp_location
  account_tier             = var.storage_inputs.account_tier
  account_replication_type = var.storage_inputs.account_replication_type

  public_network_access_enabled = false
}