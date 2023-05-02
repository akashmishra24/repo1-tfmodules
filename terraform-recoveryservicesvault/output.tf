output "recovery_vault_name" {
  value       = [for x in azurerm_recovery_services_vault.this : x.name]
  description = "Map of Recovery Services Vault and Azure VM Backup Policy Resources"
}

output "recovery_vaults_id" {
  value       = [for x in azurerm_recovery_services_vault.this : x.id]
  description = "" 
}

output "backup_policy_id" {
  value       = [for x in azurerm_backup_policy_vm.this : x.id] 
  description = "" 
}