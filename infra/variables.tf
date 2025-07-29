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