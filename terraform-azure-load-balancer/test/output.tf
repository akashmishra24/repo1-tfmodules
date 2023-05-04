output "lb_private_name" {
  value = azurerm_lb.azlb.name
}

output "lb_public_name" {
  value = azurerm_public_ip.azlb[*].name
}

output "public_address_name" {
  value = azurerm_public_ip.azlb[*].name
}

output "resource_group_name" {
  value = data.azurerm_resource_group.azlb.name
}