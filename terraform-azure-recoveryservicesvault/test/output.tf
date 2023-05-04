output "resource_group_name" {
  value = data.azurerm_resource_group.this.name
}

output "recovery_service_vault_name" {
  value = azurerm_recovery_services_vault.this[each.key].name
}

output "backup_policy_vm_name" {
  value = azurerm_backup_policy_vm.this[each.key].name
}