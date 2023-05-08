output "resource_group_name" {
  value = data.azurerm_resource_group.this.name
}

output "recovery_service_vault_name" {
  value = azurerm_backup_policy_vm.this[*].recovery_vault_name
}

output "backup_policy_vm_name" {
  value = azurerm_backup_policy_vm.this[*].name
}