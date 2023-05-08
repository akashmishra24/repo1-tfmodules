data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}

resource "azurerm_resource_group" "new_rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.prefix}"
  location            = var.create_resource_group == false ? data.azurerm_resource_group.existing_rg[0].location : azurerm_resource_group.new_rg[0].location
  resource_group_name = var.create_resource_group == false ? data.azurerm_resource_group.existing_rg[0].name : azurerm_resource_group.new_rg[0].name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_server_ip
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan
    content {
      id     = ddos_protection_plan.value["id"]
      enable = ddos_protection_plan.value["enable"]
    }
  }
}

resource "azurerm_subnet" "snet" {
  for_each                                      = var.subnets
  name                                          = each.value["name"]
  resource_group_name                           = var.create_resource_group == false ? data.azurerm_resource_group.existing_rg[0].name : azurerm_resource_group.new_rg[0].name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = each.value["address_prefixes"]
  service_endpoints                             = lookup(each.value, "service_endpoints", [])
  service_endpoint_policy_ids                   = lookup(each.value, "service_endpoint_policy_ids", null)
  private_endpoint_network_policies_enabled     = lookup(each.value, "private_endpoint_network_policies_enabled", false)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", false)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []
    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }
}

resource "azurerm_subnet" "fw-snet" {
  count                = var.firewall_subnet_address_prefix != null ? 1 : 0
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.create_resource_group == false ? data.azurerm_resource_group.existing_rg[0].name : azurerm_resource_group.new_rg[0].name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.firewall_subnet_address_prefix
  service_endpoints    = var.firewall_service_endpoints
}

resource "azurerm_subnet" "gw_snet" {
  count                = var.gateway_subnet_address_prefix != null ? 1 : 0
  name                 = "GatewaySubnet"
  resource_group_name  = var.create_resource_group == false ? data.azurerm_resource_group.existing_rg[0].name : azurerm_resource_group.new_rg[0].name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.gateway_subnet_address_prefix
  service_endpoints    = var.gateway_service_endpoints
}
