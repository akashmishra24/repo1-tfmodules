output "resource_group_name" {
  value = data.azurerm_resource_group.rgrp.name
}

output "loganalytics_workspace_name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "loganalytics_workspace_sku" {
  value = azurerm_log_analytics_workspace.law.sku
}

output "loganalytics_workspace_retention" {
  value = azurerm_log_analytics_workspace.law.retention_in_days
}