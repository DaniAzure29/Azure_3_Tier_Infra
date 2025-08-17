output "resource_group_name" {
  value = azurerm_resource_group.projectgrp.location
}

output "location" {
  value = azurerm_resource_group.projectgrp.location
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.infra_analytics.id
}

output "alert_action_group_id" {
  value = azurerm_monitor_action_group.email_group.id
}