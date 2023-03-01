data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

resource "azurerm_route_table" "rt" {
  name                = var.rt_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dynamic "route" {
    for_each = var.routes
    content {
      name                   = each.value.name
      address_prefix         = each.value.address_prefix
      next_hop_type          = each.value.next_hop_type
      next_hop_in_ip_address = lookup(each.value, "next_hop_in_ip_address", null)
    }
  }
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  tags                          = var.tags
}

resource "azurerm_subnet_route_table_association" "associate_with_subnet" {
  subnet_id      = data.azurerm_subnet.snet.id
  route_table_id = azurerm_route_table.rt.id
}

# resource "azurerm_subnet_route_table_association" "associate_with_subnet" {
#   for_each = var.subnet_ids
#   subnet_id      = each.value["subnet_id"]
#   route_table_id = azurerm_route_table.rt.id
# }
