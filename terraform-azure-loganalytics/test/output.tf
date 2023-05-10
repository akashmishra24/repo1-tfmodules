output "resource_group_name" {
  value = azurerm_resource_group.test.name
}

output "loganalytics_workspace_name" {
  value = module.loganalytics-test.name
}

output "loganalytics_workspace_sku" {
  value = module.loganalytics-test.sku
}

output "loganalytics_workspace_retention" {
  value = module.loganalytics-test.retention_in_days
}

output "key_vault" {
  value = module.loganalytics-test.key_vault
}