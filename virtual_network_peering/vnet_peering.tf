data "azurerm_resource_group" "src_rg" {
  name = var.src_vnet_rg
}

data "azurerm_resource_group" "remote_rg" {
  name = var.dest_vnet_rg
}

data "azurerm_virtual_network" "src_vnet" {
  name                = var.src_vnet_name
  resource_group_name = data.azurerm_resource_group.src_rg.name
}

data "azurerm_virtual_network" "dest_vnet" {
  name                = var.dest_vnet_name
  resource_group_name = data.azurerm_resource_group.remote_rg.name
}

resource "azurerm_virtual_network_peering" "peer-src-2-remote" {
  name                        = var.peering_src_name
  resource_group_name         = data.azurerm_resource_group.src_rg.name
  virtual_network_name        = data.azurerm_virtual_network.src_vnet.name
  remote_virtual_network_id   = data.azurerm_virtual_network.to_vnet.id
  llow_virtual_network_access = var.allow_virtual_src_network_access
  allow_forwarded_traffic     = var.allow_forwarded_src_traffic
  allow_gateway_transit       = var.allow_gateway_src_transit
  use_remote_gateways         = var.use_remote_src_gateway
}

resource "azurerm_virtual_network_peering" "peer-remote-2-src" {
  name                         = var.peering_dest_name
  resource_group_name          = data.azurerm_resource_group.remote_rg.name
  virtual_network_name         = data.azurerm_virtual_network.dest_vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.src_vnet.id
  allow_virtual_network_access = var.allow_virtual_dest_network_access
  allow_forwarded_traffic      = var.allow_forwarded_dest_traffic
  allow_gateway_transit        = var.allow_gateway_dest_transit
  use_remote_gateways          = var.use_remote_dest_gateway
}
