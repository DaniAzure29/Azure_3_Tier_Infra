variable "virtual_network_information" {
    type = object({
      resource_group_name =string
      resource_location=string
      vnet_name=string
      address_space=list(string)
      subnet_information = map(object({
      cidrblock=string 
    }))
    })
}

variable "subnet_nsg_config" {
  type = map(object({
    nsg_name  = string
    nsg_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
  description = "Configuration for subnets and their NSGs with rules"
}

variable "bastion_config" {
  type = object({
    subnet_address = string  
  })
}

variable "sshkeypath" {
  type = string
  description = "This is the public ssh key file path"
}


variable "vmss_config" {
type = map(object({
  name = string
  managed_disk_type = string
  disk_size_gb  = number
  computer_name_prefix = string
  admin_username = string
  subnet = string
  backend_pool = string
  nat_rules = string
  extension_URL = string
  command = string
  health_probe = string
  scaling = object({
    min                = number
    max                = number
    default            = number
    scale_out_metric   = string
    scale_out_threshold = number
    scale_in_metric    = string
    scale_in_threshold = number
  })
}))
}

variable "load_balancer_config" {

  type = map(object({
    name       = string
    is_public  = bool
    sku        = string
    subnet_id = optional(string)
    rules = object({
      protocol = string
      frontend_port = string
      backend_port = string
    })
    health_probe = object({
      protocol = string
      request_path = optional(string)
      port = number
      
    })
  }))
}

variable "database_config" {
  type = object({
    name = string
    admin_username = string
    storage_account_type = string
  })
}



variable "monitor_config" {
  type = object({
    alert_email = string
    VMnames = list(string)
    vmdiagnostics_config = map(object({
      enable_vm_insights = bool
      isVM = bool
    }))
  })
}