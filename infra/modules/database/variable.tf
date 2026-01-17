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

variable "rgrp_name" {
  type = string
}
variable "rgrp_location" {
  type = string
}