output "resource_group" {
  value = module.key_vault_test.resource_group
}

output "key_vault_name" {
  value = module.key_vault_test.key_vault_name
}
  
output "secret_name" {
  value = module.key_vault_test.secret_name
}

output "key_name" {
  value = module.key_vault_test.key_name
}

output "certificate_name" {
  value = module.key_vault_test.certificate_name
}
