output "kv_id" {
  value = azurerm_key_vault.key-vault.id
}

output "key_vault_url" {
  value = azurerm_key_vault.key-vault.vault_uri
}

output "key_vault_name" {
  value = azurerm_key_vault.key-vault.name
}

output "key_vault_id" {
  description = "Key Vault ID"
  value       = module.key_vault_test.key_vault_id
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
