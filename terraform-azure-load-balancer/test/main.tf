data "azurerm_resource_group" "azlb" {
  name = var.resource_group_name
}

data "azurerm_subnet" "snet" {
  count = (var.frontend_subnet_name != null && var.frontend_subnet_name != "") ? 1 : 0

  name                 = var.frontend_subnet_name
  resource_group_name  = data.azurerm_resource_group.azlb.name
  virtual_network_name = var.frontend_vnet_name
}

locals {
  data_subnet_id = try(data.azurerm_subnet.snet[0].id, "")
}

module "loadbalancer" {
  source                                 = "../"
  type                                   = var.type
  resource_group_name                    = var.resource_group_name
  frontend_subnet_id                     = var.frontend_subnet_id
  frontend_private_ip_address_allocation = var.frontend_private_ip_address_allocation
  frontend_private_ip_address            = var.frontend_private_ip_address
  lb_sku                                 = var.lb_sku
  location                               = var.location
  pip_name                               = var.pip_name
  name                                   = var.name
}