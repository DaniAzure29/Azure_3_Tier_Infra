variable "rgrp_input" {
  type = object({
    name = string
    location = string
  })
}

variable "vnet_input" {
  type = object({
    name = string
    address_space = string
    rgrp = string
    location = string
  })
}

variable "subnet_input" {
  type = map(object({
    rgrp = string
    cidr = string
    location = string
  }))
}

variable "storage_inputs" {
    type = object({
      name =  string
      account_replication_type = string
      account_tier = string
    })
}

variable "db_server_input" {
  type = object({
    name = string
    administrator_login = string
    administrator_login_password = string
    version = string
  })
}

variable "db_inputs" {
  type = object({
  name           = string
  collation      = string
  license_type   = string
  max_size_gb    = number
  read_scale     = bool
  sku_name       = string
  zone_redundant = bool
  enclave_type   = string
  })
}

variable "VMSS_config" {
    type = object({
      name = string 
      sku = string
      instances = number
      admin_username = string
        source_image_reference = object({
            publisher = string
            offer     = string
            sku       = string
            version   = string
        })
        os_disk = object({
            storage_account_type = string
            caching              = string
        })
        network_interface = object({
            name    = string
            primary = bool
            ip_configuration = object({
                name      = string
                primary   = bool
            })
        })
    })
    description = "Configuration for the Virtual Machine Scale Set"
}

variable "subnet_id" {
  type = string
  description = "subnet for VMSS"
}

variable "gateway_backend_pool_id" {
  type = string
  description = "Application Gateway backend pool ID for VMSS"
}

variable "public_ssh_key" {
  type = string
  description = "public key for VMSS"
}

variable "linux_vm_config" {
    type = object({
      name = string 
      size = string
      admin_username = string
        source_image_reference = object({
            publisher = string
            offer     = string
            sku       = string
            version   = string
        })
        os_disk = object({
            storage_account_type = string
            caching              = string
        })
    })
    description = "Configuration for the Linux Virtual Machine"
}

variable "linux_public_key" {
  type = string
  description = "Public key for linux vm"
}

variable "linux_nic_name" {
  type = string
    description = "Network Interface name for linux vm"
}
variable "nic_subnet_id" {
  type = string
  description = "Subnet_Id for Linuxvm nic"
}

variable "resorce_grp" {
  type = string
}
variable "location" {
  type = string
}

variable "gateway_config" {
  type = object({
    name = string 
    sku = object({
      name     = string
      tier     = string
      capacity = number
    })
    frontend_port = number
    backend_http_settings = object({
      cookie_based_affinity = string
      path                  = string
      port                  = number
      protocol              = string
      request_timeout       = number
    })
    http_listener = object({
      protocol                       = string
    })
    request_routing_rule = object({
      priority                   = number
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    })
  })
}   

variable "nsg_config" {
  type = map(object({
    name = string
    rules = list(object({
      name = string
      priority = number
      direction = string
      access = string 
      source_port_range = string
      destination_port_range = string
      source_address_prefix = string
      destination_address_prefix = string 
    }))
  }))
}
