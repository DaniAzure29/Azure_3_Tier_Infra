variable "private_endpoints" {
  description = "Map of private endpoints to create"
  type = map(object({
    subnet_id                = string
    private_resource_id      = string
    subresource_name         = string
    private_dns_zone_id      = string
    vnet_id                  = string
  }))
}


variable "rgrp_name" {
  type = string
}
variable "rgrp_location" {
  type = string
}
