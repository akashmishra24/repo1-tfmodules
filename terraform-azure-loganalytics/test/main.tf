#---------------------------------
# Local declarations
#---------------------------------

locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

data "azurerm_key_vault" "kv" {
  count               = var.key_vault_name != null ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name == null ? local.resource_group_name : var.key_vault_rg_name
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  name = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
}
#---------------------------------------------------------
# Create Log Analytics Workspace
#---------------------------------------------------------

module "loganalytics-admin" {
  # validate the source path before executing the module.   
  source              = "../"
  resource_group_name = var.resource_group_name
  name                = var.name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags
  depends_on = [
    data.azurerm_key_vault.kv
  ]
}
