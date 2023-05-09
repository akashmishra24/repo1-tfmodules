# #############################################################################
# # OUTPUTS Log Analytics Workspace
# #############################################################################


output "log_analytics_workspace_id" {
  description = "Specifies the id of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

output "log_analytics_workspace_key" {
  description = "Specifies the key of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.primary_shared_key
  sensitive   = true
}

output "law_workspace" {
  description = ""
  value       = azurerm_log_analytics_workspace.law
}

output "name" {
  description = ""
  value       = azurerm_log_analytics_workspace.law.name
}

output "sku" {
  description = ""
  value       = azurerm_log_analytics_workspace.law.sku
}

output "retention_in_days" {
  description = ""
  value       = azurerm_log_analytics_workspace.law.retention_in_days
}

output "law_key" {
  description = ""
  value       = azurerm_log_analytics_workspace.law.primary_shared_key
}
