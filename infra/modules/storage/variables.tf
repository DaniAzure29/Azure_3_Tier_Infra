variable "storage_inputs" {
    type = object({
      name =  string
      account_replication_type = string
      account_tier = string
    })
}
variable "rgrp_name" {
  type = string
}
variable "rgrp_location" {
  type = string
}

