module "resource_grp" {
   source = "./modules/general/resource-group"
   rgrp_input = var.rgrp_input

  }

module "vnet" {
  source = "./modules/network/vnet"
  vnet_input = var.vnet_input
  subnet_input = var.subnet_input
}