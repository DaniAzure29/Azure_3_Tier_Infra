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

variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}
variable "public_ip_address_id" {
  type = string
}
