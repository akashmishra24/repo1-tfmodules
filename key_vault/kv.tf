#---------------------------------------------------------------
# Data Sources
#---------------------------------------------------------------

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

#---------------------------------------------------------------
# Resource creation: Key Vault
#---------------------------------------------------------------

resource "azurerm_key_vault" "key-vault" {
  name                            = "kv-${var.workload}-${data.azurerm_resource_group.rg.location}-${var.environment}"
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  tenant_id                       = var.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  sku_name                        = var.sku_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  public_network_access_enabled   = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls
    iterator = acl

    content {
      bypass                     = acl.value.bypass
      default_action             = acl.value.default_action
      ip_rules                   = acl.value.ip_rules
      virtual_network_subnet_ids = acl.value.virtual_network_subnet_ids
    }
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  for_each                = var.enable_rbac_authorization ? {} : var.kv_access_policy
  key_vault_id            = azurerm_key_vault.key-vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  key_permissions         = lookup(each.value, "key_permissions", null)
  secret_permissions      = lookup(each.value, "secret_permissions", null)
  storage_permissions     = lookup(each.value, "storage_permissions", null)
  certificate_permissions = lookup(each.value, "certificate_permissions", null)
  application_id          = lookup(each.value, "application_id", null)
}

resource "azurerm_private_endpoint" "kv-pvt-endpoint" {
  count               = var.public_network_access_enabled ? 0 : 1
  name                = "${azurerm_key_vault.key-vault.name}-endpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.snet.id # data.terraform_remote_state.remote_state.outputs.subnet_id

  private_service_connection {
    name                              = "${azurerm_key_vault.key-vault.name}-privateserviceconnection"
    private_connection_resource_id    = azurerm_key_vault.key-vault.id
    private_connection_resource_alias = var.private_connection_resource_alias
    subresource_names                 = ["vault"]
    is_manual_connection              = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_group
    content {
      name                 = private_dns_zone_group.value["name"]
      private_dns_zone_ids = private_dns_zone_group.value["private_dns_zone_ids"]
    }
  }

  dynamic "ip_configuration" {
    for_each = var.ip_configuration
    content {
      name               = ip_configuration.value["name"]
      private_ip_address = ip_configuration.value["private_ip_address"]
      subresource_name   = ip_configuration.value["subresource_name"]
      # member_name        = ip_configuration.value["member_name"]
    }
  }
}

resource "azurerm_key_vault_key" "kv_key" {
  for_each        = var.kv_key
  name            = each.value["name"]
  key_vault_id    = azurerm_key_vault.key-vault.id
  key_type        = each.value["key_type"]
  key_size        = each.value["key_size"]
  curve           = lookup(each.value, "curve", null)
  not_before_date = lookup(each.value, "not_before_date", null)
  expiration_date = lookup(each.value, "expiration_date", null)
  key_opts        = each.value["key_opts"]
}
