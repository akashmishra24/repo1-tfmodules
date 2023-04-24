

output "resource_group_name" {
   value = [for x in data.azurerm_resource_group.rg : x.resource_group_name]
}

output "key_vault_name" {
  description = "The Name of the Key Vault"
  value       = azurerm_key_vault.key-vault.name
}
   
 output "key_vault_id" {
  value = azurerm_key_vault.key-vault.id
}
