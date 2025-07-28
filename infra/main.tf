resource "azurerm_resource_group" "projectgrp" {
  name     = var.virtual_network_information.resource_group_name
  location = var.virtual_network_information.resource_location
}

