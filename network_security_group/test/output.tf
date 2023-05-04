output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg.name
}

output "ssh_rule_name" {
  value = azurerm_network_security_rule.allow_ssh.name
}

output "http_rule_name" {
  value = azurerm_network_security_rule.block_http.name
}