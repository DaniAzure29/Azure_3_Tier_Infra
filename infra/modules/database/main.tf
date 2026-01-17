resource "azurerm_mssql_server" "db_server" {
  name                         = var.db_server_input.name
  resource_group_name          = var.rgrp_name
  location                     = var.rgrp_location
  version                      = var.db_server_input.version
  administrator_login          = var.db_server_input.administrator_login
  administrator_login_password = var.db_server_input.administrator_login_password

  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "db" {
  name           = var.db_inputs.name
  server_id      = azurerm_mssql_server.db_server.id
  collation      = var.db_inputs.collation
  license_type   = var.db_inputs.license_type
  max_size_gb    = var.db_inputs.max_size_gb
  read_scale     = var.db_inputs.read_scale
  sku_name       = var.db_inputs.sku_name
  zone_redundant = var.db_inputs.zone_redundant
  enclave_type   = var.db_inputs.enclave_type

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}