resource "azurerm_linux_virtual_machine_scale_set" "scaleset" {
  for_each = var.vmss_config
  name                = each.value.name
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name
  sku                 = "Standard_F2"
  instances           = each.value.scaling.default
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.sshkeypath)
  }

  identity {type = "SystemAssigned"}



  # automatic rolling upgrade
  upgrade_mode = "Automatic"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.probes[each.value.health_probe].id


    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = each.value.managed_disk_type
    caching              = "ReadWrite"
  }

  data_disk {
     name              = "${each.value.name}-disk"
     lun = 0
     caching       = "ReadWrite"
     create_option = "Empty"
     disk_size_gb  = each.value.disk_size_gb
     storage_account_type = each.value.managed_disk_type
  }

  network_interface {
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

resource "azurerm_virtual_machine_scale_set_extension" "scale_set_extension" {
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

resource "azurerm_virtual_machine_scale_set_extension" "AADlogin" {
  for_each = var.vmss_config
  name                       = "AADLoginForLinux"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.scaleset[each.value.name].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

resource "azurerm_monitor_autoscale_setting" "vmss" {
  for_each = var.vmss_config

  name                = "${each.key}-autoscale"
  resource_group_name = azurerm_resource_group.projectgrp.name
  location            = azurerm_resource_group.projectgrp.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.scaleset[each.key].id

  profile {
    name = "${each.key}-profile"

    capacity {
      minimum = each.value.scaling.min
      maximum = each.value.scaling.max
      default = each.value.scaling.default
    }

    # Scale out
    rule {
      metric_trigger {
        metric_name        = each.value.scaling.scale_out_metric
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.scaleset[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = each.value.scaling.scale_out_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    # Scale in
    rule {
      metric_trigger {
        metric_name        = each.value.scaling.scale_in_metric
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.scaleset[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = each.value.scaling.scale_in_threshold
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }
}
resource "azurerm_network_interface" "dbinterface" {
  name                = "database-nic"
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name

  ip_configuration {
    name                          = "dbipconfig"
    subnet_id                     = azurerm_subnet.infra_subnets["dbsubnet"].id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_linux_virtual_machine" "databasevm" {
  name                = var.database_config.name
  resource_group_name = azurerm_resource_group.projectgrp.name
  location            = azurerm_resource_group.projectgrp.location
  size                = "Standard_F2"
  admin_username      = var.database_config.admin_username
  
  admin_ssh_key {
      username = var.database_config.admin_username
      public_key = file(var.sshkeypath)
    }

  identity {type = "SystemAssigned"}

  network_interface_ids = [
    azurerm_network_interface.dbinterface.id,
  ]

 

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.database_config.storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "aadlogin" {
  name                 = "AADLoginForLinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.databasevm.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADLoginForLinux"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true
}

