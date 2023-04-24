

output "resource_group_name" {
   value = [for x in azurerm_resource_group.rg : x.resource_group_name]
}

output "key_vault_name" {
  value = [for x in azurerm_key_vault.key-vault : x.name]
}
  
output "secret_name" {
  value = [for x in azurerm_key_vault.key-vault : x.secret_name]
}

output "key_name" {
  value = [for x in azurerm_key_vault.key-vault : x.key_name]
}

output "certificate_name" {
  value = [for x in azurerm_key_vault.key-vault : x.certificate_name]
}
