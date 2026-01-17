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

  validation {
    condition = alltrue([
      for nsg in var.nsg_config :
      length(distinct([for r in nsg.rules : r.priority])) == length(nsg.rules)
    ])
    error_message = "NSG rules within the same NSG must have unique priorities."
  }
}

variable "resource_grp" {
  type = string
}
variable "location" {
  type = string
}


