output "resource_group_name" {
  value = data.azurerm_resource_group.rgrp.name
}

output "loganalytics_workspace_name" {
  value = module.loganalytics.name
}

output "loganalytics_workspace_sku" {
  value = module.loganalytics.sku
}

output "loganalytics_workspace_retention" {
  value = module.loganalytics.retention_in_days
}