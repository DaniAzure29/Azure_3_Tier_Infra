variable "vnet_input" {
  type = object({
    name = string
    address_space = string
    location = string
    rgrp = string
  })
}

variable "subnet_input" {
  type = map(object({
    rgrp = string
    cidr = string
  }))
}