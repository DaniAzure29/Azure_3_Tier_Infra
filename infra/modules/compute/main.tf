resource "azurerm_linux_virtual_machine_scale_set" "Web_VMSS" {
  name                = var.VMSS_config.name
  resource_group_name = var.resorce_grp
  location            = var.location
  sku                 = var.VMSS_config.sku
  instances           = var.VMSS_config.instances
  admin_username = var.VMSS_config.admin_username

  admin_ssh_key {
    username   = var.VMSS_config.admin_username
    public_key = var.public_ssh_key
  }
  
  source_image_reference {
    publisher = var.VMSS_config.source_image_reference.publisher
    offer     = var.VMSS_config.source_image_reference.offer
    sku       = var.VMSS_config.source_image_reference.sku
    version   = var.VMSS_config.source_image_reference.version
  }
  
  os_disk {
    storage_account_type = var.VMSS_config.os_disk.storage_account_type
    caching              = var.VMSS_config.os_disk.caching
  }

  network_interface {
    name    = var.VMSS_config.network_interface.name
    primary = var.VMSS_config.network_interface.primary

    ip_configuration {
      name      = var.VMSS_config.network_interface.ip_configuration.name
      primary   = var.VMSS_config.network_interface.ip_configuration.primary
      subnet_id = var.subnet_id
      application_gateway_backend_address_pool_ids = [var.gateway_backend_pool_id]
    }
  }


}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = var.linux_vm_config.name
  resource_group_name = var.resorce_grp
  location            = var.location
  size                = var.linux_vm_config.size
  admin_username      = var.linux_vm_config.admin_username
  network_interface_ids = [
    azurerm_network_interface.linux_vm_nic.id
  ]

  admin_ssh_key {
    username   = var.linux_vm_config.admin_username
    public_key = var.linux_public_key
  }

  os_disk {
    caching              = var.linux_vm_config.os_disk.caching
    storage_account_type = var.linux_vm_config.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.linux_vm_config.source_image_reference.publisher
    offer     = var.linux_vm_config.source_image_reference.offer
    sku       = var.linux_vm_config.source_image_reference.sku
    version   = var.linux_vm_config.source_image_reference.version
  }
  identity {
    type = "SystemAssigned"
    }

}

resource "azurerm_network_interface" "linux_vm_nic" {
  name                = var.linux_nic_name
  location            = var.location
  resource_group_name = var.resorce_grp

  ip_configuration {
    name                          = "${var.linux_nic_name}-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
  }
}

