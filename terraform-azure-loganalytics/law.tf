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
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
}
#---------------------------------------------------------
# Create Log Analytics Workspace
#----------------------------------------------------------
resource "azurerm_log_analytics_workspace" "law" {
  name                               = var.law_name
  resource_group_name                = local.resource_group_name
  location                           = local.location
  sku                                = var.sku
  retention_in_days                  = var.retention_in_days
  allow_resource_only_permissions    = var.allow_resource_only_permissions
  local_authentication_disabled      = var.local_authentication_disabled
  daily_quota_gb                     = var.daily_quota_gb
  reservation_capacity_in_gb_per_day = var.sku == "CapacityReservation" ? var.reservation_capacity_in_gb_per_day : null
  internet_ingestion_enabled         = var.internet_ingestion_enabled
  internet_query_enabled             = var.internet_query_enabled
  tags                               = var.tags
}

resource "azurerm_log_analytics_solution" "law_solution" {
  for_each              = var.las
  solution_name         = each.value["solution_name"]
  location              = local.location
  resource_group_name   = local.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name
  tags                  = each.value["tags"]
  plan {
    publisher = each.value["publisher"]
    product   = each.value["product"]
  }
}

resource "azurerm_key_vault_secret" "law_primary_key" {
  count        = var.key_vault_name != null ? 1 : 0
  name         = "${var.law_name}-primary-key"
  value        = azurerm_log_analytics_workspace.law.primary_shared_key
  key_vault_id = data.azurerm_key_vault.kv.0.id
}

resource "azurerm_key_vault_secret" "law_secondary_key" {
  count        = var.key_vault_name != null ? 1 : 0
  name         = "${var.law_name}-secondary-key"
  value        = azurerm_log_analytics_workspace.law.secondary_shared_key
  key_vault_id = data.azurerm_key_vault.kv.0.id
}