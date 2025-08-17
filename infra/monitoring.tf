# 1. Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "infra_analytics" {
  name                = "infra_analytics"
  location            = azurerm_resource_group.projectgrp.location
  resource_group_name = azurerm_resource_group.projectgrp.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# 2. Diagnostic Settings for Web VMSS, App VMSS and DB Vm
resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
    for_each = var.monitor_config.vmdiagnostics_config
  count                      = each.value.enable_vm_insights ? 1 : 0
  name                       = "${each.key}-diagnostics"
  target_resource_id         = each.value.isVM ? azurerm_linux_virtual_machine.databasevm : azurerm_linux_virtual_machine_scale_set.scaleset[each.key].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "Syslog"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}



# 3. Alert Action Group
resource "azurerm_monitor_action_group" "email_group" {
  name                = "infra-alert-group"
  resource_group_name =  azurerm_resource_group.projectgrp.name
  short_name          = "Infraalert"

  email_receiver {
    name          = "alert-email"
    email_address = var.monitor_config.alert_email
  }
}

# 4. Example CPU Alert for All VMs
resource "azurerm_monitor_metric_alert" "cpu_alert_all" {
  name                = "cpu-high-alert-all"
  resource_group_name = azurerm_resource_group.projectgrp.name
  scopes = [
    azurerm_linux_virtual_machine_scale_set.scaleset[var.monitor_config.VMnames[0]].id,
    azurerm_linux_virtual_machine_scale_set.scaleset[var.monitor_config.VMnames[0]].id,
    azurerm_linux_virtual_machine.databasevm.id
  ]
  description = "Alert when CPU usage exceeds 80% for any tier"
  severity    = 2
  frequency   = "PT1M"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_group.id
  }
}