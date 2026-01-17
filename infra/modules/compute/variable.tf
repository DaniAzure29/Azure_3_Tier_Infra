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