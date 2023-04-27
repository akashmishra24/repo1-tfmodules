output "kv_id" {
  value = azurerm_key_vault.key-vault.id
  #value = module.key_vault_test.key_vault_id
}

output "key_vault_url" {
  value = azurerm_key_vault.key-vault.vault_uri
  #value = module.key_vault_test.vault_uri
}

output "key_vault_name" {
  value = azurerm_key_vault.key-vault.name
  #value = module.key_vault_test.name
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
