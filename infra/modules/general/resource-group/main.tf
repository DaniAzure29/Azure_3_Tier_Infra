resource "azurerm_resource_group" "projectgrp" {
  name = var.rgrp_input.name
  location = var.rgrp_input.location
}

