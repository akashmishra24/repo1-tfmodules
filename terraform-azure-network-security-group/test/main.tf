data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# data "azurerm_subnet" "snet" {
#   name                 = var.subnet_name
#   virtual_network_name = var.vnet_name
#   resource_group_name  = data.azurerm_resource_group.rg.name
# }

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.nsg_prefix}-${var.workload}-${data.azurerm_resource_group.rg.location}-${var.environment}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                         = security_rule.value["name"]
      priority                     = security_rule.value["priority"]
      direction                    = security_rule.value["direction"]
      access                       = security_rule.value["access"]
      protocol                     = security_rule.value["protocol"]
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
    }
  }
}

# resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
#   subnet_id                 = data.azurerm_subnet.snet.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each                  = var.subnet_ids
  subnet_id                 = each.value["subnet_id"]
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_network_security_group.nsg
  ]
}
