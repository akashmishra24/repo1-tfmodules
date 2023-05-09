output "lb_private_name" {
  value = module.loadbalancer.name
}

output "lb_public_name" {
  value = module.loadbalancer.pip_name
}


output "public_address_name" {
  value = module.loadbalancer.pip_name
}

output "resource_group_name" {
  value = data.azurerm_resource_group.azlb.name
}