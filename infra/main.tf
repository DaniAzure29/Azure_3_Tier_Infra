module "resource_grp" {
   source = "./modules/general/resource-group"
   rgrp_input = var.rgrp_input

  }
module "vnet" {
  source = "./modules/network/vnet"
  vnet_input = var.vnet_input
  subnet_input = var.subnet_input

}
module "storage" {
  source = "./modules/storage"
  storage_inputs = var.storage_inputs
  rgrp_name = module.resource_grp.name
  rgrp_location = module.resource_grp.location
}
module "database" {
  source = "./modules/database"
  db_server_input = var.db_server_input
  db_inputs = var.db_inputs
  rgrp_name = module.resource_grp.name
  rgrp_location = module.resource_grp.location
}
module "compute" {
  source = "./modules/compute"
  VMSS_config = var.VMSS_config
  subnet_id = module.vnet.subnet_ids["web-tier"]
  gateway_backend_pool_id = module.networking.app_gateway_backend_pool_id
  public_ssh_key = file("~/.ssh/id_rsa.pub")
  linux_vm_config = var.linux_vm_config
  linux_public_key = file("~/.ssh/id_rsa.pub")
  linux_nic_name = var.linux_nic_name
  nic_subnet_id = module.vnet.subnet_ids["app-tier"]
  resorce_grp = module.resource_grp.name
  location = module.resource_grp.location
}
module "networking" {
  source = "./modules/app-gateway"
  gateway_config = var.gateway_config
  resource_group_name = module.resource_grp.name
  location = module.resource_grp.location
  subnet_id = module.vnet.subnet_ids["gateway-subnet"]
  public_ip_address_id = module.networking.public_ip_id
}

module "endpoints" {
  source = "./modules/endpoints"
  private_endpoints = {
    storage = {
      subnet_id           = module.vnet.subnet_ids["endpoint"]
      private_resource_id = module.storage.storage_account_id
      subresource_name    = "blob"
      private_dns_zone_id = module.storage.private_dns_zone_id
      vnet_id             = module.vnet.vnet_id
    }
    db = {
      subnet_id           = module.vnet.subnet_ids["endpoint"]
      private_resource_id = module.database.db_server_id
      subresource_name    = "sqlServer"
      private_dns_zone_id = module.database.private_dns_zone_id
      vnet_id             = module.vnet.vnet_id
    }    
  }
  rgrp_name = module.resource_grp.name  
  rgrp_location = module.resource_grp.location
}

module "nsg" {
  source = "./modules/nsg"
  nsg_config = var.nsg_config
  resource_grp = module.resource_grp.name
  location = module.resource_grp.location
}