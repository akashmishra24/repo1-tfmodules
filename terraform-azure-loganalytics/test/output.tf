output "resource_group_name" {
  value = data.azurerm_resource_group.rgrp.name
}

output "loganalytics_workspace_name" {
  value = module.loganalytics-admin.name
}

output "loganalytics_workspace_sku" {
  value = module.loganalytics-admin.sku
}

output "loganalytics_workspace_retention" {
  value = module.loganalytics-admin.retention_in_days
}