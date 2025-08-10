resource "azurerm_virtual_machine_scale_set" "scaleset" {
  for_each = var.vmss_config
  name                = each.value.name
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.example.id

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = "${each.value.name}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = each.value.managed_disk_type
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = each.value.disk_size_gb
  }

  os_profile {
    computer_name_prefix = each.value.computer_name_prefix
    admin_username       = each.value.admin_username
    admin_password = ""
  }

 

  network_profile {
    name    = "${each.value.name}-network"
    primary = true

    ip_configuration {
      name                                   = "${each.value.name}-ipconfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.infra_subnets[each.value.subnet].id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.vm_pool[each.value.backend_pool].id]
    }
  }

  
}

resource "azurerm_virtual_machine_scale_set_extension" "example" {
  for_each = var.vmss_config
  name                         = "${each.key}-extension"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.scaleset[each.value.name].id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"
  settings = jsonencode({
    fileUris          = [each.value.extension_URL]
    commandToExecute  = each.value.command
  })
}
    