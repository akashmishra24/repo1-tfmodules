#---------------------------------------------------------------
# Data Sources
#---------------------------------------------------------------

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "primary_rg" {
  name = var.primary_resource_group_name
}

data "azurerm_virtual_network" "primary_vnet" {
  name                = var.primary_vnet_name
  resource_group_name = data.azurerm_resource_group.primary_rg.name
}

data "azurerm_subnet" "primary_snet" {
  name                 = var.primary_subnet_name
  virtual_network_name = data.azurerm_virtual_network.primary_vnet.name
  resource_group_name  = data.azurerm_resource_group.primary_rg.name
}

data "azurerm_resource_group" "secondary_rg" {
  count = var.failover_needed ? 1 : 0
  name  = var.secondary_resource_group_name
}

data "azurerm_virtual_network" "secondary_vnet" {
  count               = var.failover_needed ? 1 : 0
  name                = var.secondary_vnet_name
  resource_group_name = var.secondary_resource_group_name
}

data "azurerm_subnet" "secondary_snet" {
  count                = var.failover_needed ? 1 : 0
  name                 = var.secondary_subnet_name
  virtual_network_name = var.secondary_vnet_name
  resource_group_name  = var.secondary_resource_group_name
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

#---------------------------------------------------------------
# Resource Creation: Random password and SQL MI
#---------------------------------------------------------------

resource "random_password" "sql_password" {
  count            = var.failover_needed ? 2 : 1
  length           = 8
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  number           = true
  override_special = "_"
  special          = true
  upper            = true
}

resource "azurerm_mssql_managed_instance" "sql_mi_primary" {
  name                         = "sqlmi-${var.workload}-${var.environment}-primary"
  resource_group_name          = data.azurerm_resource_group.primary_rg.name
  location                     = data.azurerm_resource_group.primary_rg.location
  administrator_login          = var.sql_mi_admin
  administrator_login_password = random_password.sql_password[0].result
  license_type                 = var.sql_mi_license
  subnet_id                    = data.azurerm_subnet.primary_snet.id
  sku_name                     = var.sql_mi_sku
  vcores                       = var.sql_mi_vcore
  storage_size_in_gb           = var.sql_mi_storage_size
  dns_zone_partner_id          = var.dns_zone_partner_id
  public_data_endpoint_enabled = false
  storage_account_type         = var.storage_account_type
  timezone_id                  = var.timezone_id
  proxy_override               = var.proxy_override
  minimum_tls_version          = var.minimum_tls_version
  tags                         = var.tags == {} ? { "Environment" = "${var.environment}", "Workload" = "${var.workload}" } : var.tags

  identity {
    type = var.identity ? "SystemAssigned" : null
  }
}

#---------------------------------------------------------------
# Resource Creation: SQL MI Failover Group
#---------------------------------------------------------------

resource "azurerm_mssql_managed_instance" "sql_mi_secondary" {
  count                        = var.failover_needed ? 1 : 0
  name                         = "sqlmi-${var.workload}-${var.environment}-secondary"
  resource_group_name          = var.secondary_resource_group_name
  location                     = data.azurerm_resource_group.secondary_rg[0].location
  administrator_login          = var.sql_mi_admin_secondary
  administrator_login_password = random_password.sql_password[1].result
  license_type                 = var.sql_mi_license_secondary == null ? var.sql_mi_license : var.sql_mi_license_secondary
  subnet_id                    = data.azurerm_subnet.secondary_snet[0].id
  sku_name                     = var.sql_mi_sku_secondary == null ? var.sql_mi_sku : var.sql_mi_sku_secondary
  vcores                       = var.sql_mi_vcore_secondary == null ? var.sql_mi_vcore : var.sql_mi_vcore_secondary
  storage_size_in_gb           = var.sql_mi_storage_size_secondary == null ? var.sql_mi_storage_size : var.sql_mi_storage_size_secondary
  dns_zone_partner_id          = var.dns_zone_partner_id
  public_data_endpoint_enabled = false
  storage_account_type         = var.storage_account_type_secondary == null ? var.storage_account_type : var.storage_account_type_secondary
  timezone_id                  = var.timezone_id
  proxy_override               = var.proxy_override
  minimum_tls_version          = var.minimum_tls_version
  tags                         = var.tags == {} ? { "Environment" = "${var.environment}", "Workload" = "${var.workload}" } : var.tags

  identity {
    type = var.identity ? "SystemAssigned" : null
  }
}

resource "azurerm_mssql_managed_instance_failover_group" "this" {
  count                       = var.failover_needed ? 1 : 0
  name                        = var.failover_group_name
  location                    = azurerm_mssql_managed_instance.sql_mi_primary.location
  managed_instance_id         = azurerm_mssql_managed_instance.sql_mi_primary.id
  partner_managed_instance_id = azurerm_mssql_managed_instance.sql_mi_secondary[0].id

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}

#---------------------------------------------------------------
# Resource Creation: KeyVault Secret to store admin passwords
#---------------------------------------------------------------

resource "azurerm_key_vault_secret" "sql_admin_password_primary" {
  name         = "sec-${var.workload}-${var.environment}-primary"
  value        = random_password.sql_password[0].result
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "sql_admin_password_secondary" {
  count        = var.failover_needed ? 1 : 0
  name         = "sec-${var.workload}-${var.environment}-secondary"
  value        = random_password.sql_password[1].result
  key_vault_id = data.azurerm_key_vault.kv.id
}
