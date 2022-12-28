data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_key_vault" "this" {
  count               = var.cmk_key_vault != null ? 1 : 0
  name                = var.cmk_key_vault.key_vault_name
  resource_group_name = var.cmk_key_vault.key_vault_rg_name
}

#----------------------------------------------------------
# Storage Account Creation
#----------------------------------------------------------
resource "azurerm_storage_account" "this" {
  for_each                      = var.storage_accounts
  name                          = each.value["name"]
  resource_group_name           = data.azurerm_resource_group.this.name
  location                      = data.azurerm_resource_group.this.location
  account_tier                  = coalesce(lookup(each.value, "account_kind"), "StorageV2") == "FileStorage" ? "Premium" : split("_", each.value["sku"])[0] 
  account_replication_type      = coalesce(lookup(each.value, "account_kind"), "StorageV2") == "FileStorage" ? "LRS" : split("_", each.value["sku"])[1]
  account_kind                  = coalesce(lookup(each.value, "account_kind"), "StorageV2")
  access_tier                   = lookup(each.value, "access_tier", null)
  enable_https_traffic_only     = true                                                      
  min_tls_version               = "TLS1_2"                                                  
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", null)

  identity {
    type         = coalesce(lookup(each.value, "managed_identity_type"), "SystemAssigned")
    identity_ids = each.value.managed_identity_type == "UserAssigned" || each.value["managed_identity_type"] == "SystemAssigned, UserAssigned" ? each.value["managed_identity_ids"] : []
  }

  dynamic "network_rules" {
    for_each = lookup(each.value, "network_rules", null) != null ? [merge(local.default_network_rules, lookup(each.value, "network_rules", null))] : [local.disable_network_rules]
    content {
      bypass                     = lookup(network_rules.value, "bypass", null)
      default_action             = lookup(network_rules.value, "default_action", null)
      ip_rules                   = lookup(network_rules.value, "ip_rules", null)
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids", null)
    }
  }

  blob_properties {
    delete_retention_policy {
      days = lookup(each.value, "blob_retention_days", 30)
    }
    container_delete_retention_policy {
      days = lookup(each.value, "container_soft_delete_retention_days", 30)
    }
    versioning_enabled            = true 
    change_feed_enabled           = true
    change_feed_retention_in_days = lookup(each.value, "change_feed_retention_in_days", 30)
  }

  tags = local.tags
}

#-------------------------------
# Storage Container Creation
#-------------------------------
resource "azurerm_storage_container" "this" {
  for_each              = var.containers
  name                  = each.value["name"]
  storage_account_name  = each.value["storage_account_name"]
  container_access_type = coalesce(lookup(each.value, "container_access_type"), "private")
  depends_on = [
    azurerm_storage_account.this,
    azurerm_private_endpoint.this,
    azurerm_private_dns_a_record.this
  ]
}

#-------------------------------
# Storage Blobs Creation
#-------------------------------
resource "azurerm_storage_blob" "this" {
  for_each               = local.blobs
  name                   = each.value["name"]
  storage_account_name   = each.value["storage_account_name"]
  storage_container_name = each.value["storage_container_name"]
  type                   = each.value["type"]
  size                   = lookup(each.value, "size", null)
  content_type           = lookup(each.value, "content_type", null)
  source_uri             = lookup(each.value, "source_uri", null)
  metadata               = lookup(each.value, "metadata", null)
  depends_on = [
    azurerm_storage_account.this,
    azurerm_storage_container.this,
    azurerm_private_endpoint.this,
    azurerm_private_dns_a_record.this
  ]
}

#-------------------------------
# Storage Queue Creation
#-------------------------------
resource "azurerm_storage_queue" "this" {
  for_each             = var.queues
  name                 = each.value["name"]
  storage_account_name = each.value["storage_account_name"]
  depends_on = [
    azurerm_storage_account.this,
    azurerm_private_endpoint.this,
    azurerm_private_dns_a_record.this
  ]
}

#-------------------------------
# Storage Fileshare Creation
#-------------------------------
resource "azurerm_storage_share" "this" {
  for_each             = var.file_shares
  name                 = each.value["name"]
  storage_account_name = each.value["storage_account_name"]
  quota                = coalesce(lookup(each.value, "quota"), 110)
  depends_on = [
    azurerm_storage_account.this,
    azurerm_private_endpoint.this,
    azurerm_private_dns_a_record.this
  ]
}

#-------------------------------
# Storage Tables Creation
#-------------------------------
resource "azurerm_storage_table" "this" {
  for_each             = var.tables
  name                 = each.value["name"]
  storage_account_name = each.value["storage_account_name"]
  depends_on = [
    azurerm_storage_account.this,
    azurerm_private_endpoint.this,
    azurerm_private_dns_a_record.this
  ]
}

#---------------------------------------------------
# - Private endpoint for Storage account
#---------------------------------------------------
locals {
  sa_ids_map = { for sa in azurerm_storage_account.this : sa.name => sa.id }
}

resource "azurerm_private_endpoint" "this" {
  for_each            = { for k, v in var.private_endpoints : k => v if v.subnet_id != "" && v.subresource_name != "" && v.storage_account_key != "" }
  name                = "${each.value["storage_account_key"]}-${each.value["subresource_name"]}-pe"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  subnet_id           = each.value["subnet_id"]

  private_service_connection {
    name                           = "${each.value["storage_account_key"]}-connection"
    private_connection_resource_id = lookup(local.sa_ids_map, each.value["storage_account_key"], null)
    is_manual_connection           = false
    subresource_names              = [each.value["subresource_name"]]
    request_message                = null
  }

  lifecycle {
    ignore_changes = [
      private_service_connection[0].private_connection_resource_id
    ]
  }

  tags       = local.tags
  depends_on = [azurerm_storage_account.this]
}

#---------------------------------------------------
# - Add A record in the Private DNS zone 
#---------------------------------------------------
resource "azurerm_private_dns_a_record" "this" {
  for_each            = { for k, v in var.private_endpoints : k => v if v.private_dns_zone_name != "" && v.resource_group_name != "" && v.storage_account_key != "" }
  name                = each.value["storage_account_key"]
  zone_name           = each.value["private_dns_zone_name"]
  resource_group_name = each.value["resource_group_name"]
  ttl                 = "10"
  records             = [azurerm_private_endpoint.this[each.key].private_service_connection[0].private_ip_address]
  tags                = local.tags
  depends_on          = [azurerm_storage_account.this, azurerm_private_endpoint.this]
}

#---------------------------------------------------
# - Add Storage account System assigned Managed Identity to Key vault access Policy
#---------------------------------------------------
resource "azurerm_key_vault_access_policy" "this" {
  for_each                = { for k, v in var.storage_accounts : k => v if var.cmk_key_vault != null }
  key_vault_id            = data.azurerm_key_vault.this[0].id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = azurerm_storage_account.this[each.key].identity.0.principal_id
  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions
  depends_on = [
    azurerm_storage_account.this
  ]
}

#---------------------------------------------------
# - Add CMK for Storage account
#---------------------------------------------------
resource "azurerm_storage_account_customer_managed_key" "this" {
  for_each           = { for k, v in var.storage_accounts : k => v if var.cmk_key_vault != null }
  storage_account_id = azurerm_storage_account.this[each.key].id
  key_vault_id       = data.azurerm_key_vault.this[0].id
  key_name           = var.cmk_key_vault.key_vault_key_name
  depends_on         = [azurerm_storage_account.this, azurerm_key_vault_access_policy.this]
}

#---------------------------------------------------
# - Add Diagnostics settings for Storage account
#---------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each                   = { for k, v in var.storage_accounts : k => v if var.log_analytics_workspace_id != "" }
  name                       = "${each.value["name"]}-diag"
  target_resource_id         = azurerm_storage_account.this[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "Transaction"
    retention_policy {
      enabled = false
    }
  }
  lifecycle {
    ignore_changes = [log, metric]
  }
  depends_on = [azurerm_storage_account.this]
}

#--------------------------------------
# - Storage Advanced Threat Protection 
#--------------------------------------
resource "azurerm_advanced_threat_protection" "this" {
  for_each           = var.storage_accounts
  target_resource_id = azurerm_storage_account.this[each.key].id
  enabled            = true
  depends_on         = [azurerm_storage_account.this]
}
