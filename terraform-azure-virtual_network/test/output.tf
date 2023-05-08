#output "azurerm_subnet_id" {
#    value = {
#        for id in keys(var.subnets) : id => azurerm_virtual_network.subnet[id].id
#    }
#    description = "List of the IDs of the subnets created"
#}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "virtual_network_name" {
  description = "The id of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = [for s in azurerm_subnet.snet : s.id]
}


output "resource_group_name" {
  value = data.azurerm_resource_group.existing_rg.name
}


output "subnet_name" {
  value = azurerm_subnet.snet.name
}


output "firewall_name" {
  value = azurerm_subnet.fw_snet.name
}

output "gateway_name" {
  value = azurerm_subnet.gw_snet.name
}

