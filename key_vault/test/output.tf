output "resource_group_name" {
  value = module.key_vault_test.resource_group_name
}

output "key_vault_name" {
  value = module.key_vault_test.key_vault_name
}

output "key_vault_id" {
  value = azurerm_key_vault.key-vault.id
}
  
output "secret_name" {
  value = azurerm_key_vault_secret.this.name
}

output "key_name" {
  value = azurerm_key_vault_key.key_name.name
}

output "certificate_name" {
  value = azurerm_key_vault_certificate.certificate_name.name
}
