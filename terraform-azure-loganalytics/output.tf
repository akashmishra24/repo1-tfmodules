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

output "law_name" {
  description = ""
  value       = azurerm_log_analytics_workspace.law.name
}

output "law_key" {
  description = ""
  value       = azurerm_log_analytics_workspace.law.primary_shared_key
}


output "law_id_map" {
  value = {
    for x in list(azurerm_log_analytics_workspace.law) :
    x.name => x.id
  }
}