output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg.name
}
