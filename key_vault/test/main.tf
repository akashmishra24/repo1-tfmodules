locals {
  location = "eastus"
}

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

resource "azurerm_key_vault_certificate" "certificate_name" {
  name         = var.certificate_name
  key_vault_id = module.key_vault_test.key_vault_id
  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
  
}

resource "azurerm_key_vault_secret" "this" {
  name         = var.secret_name
  value        = var.value
  key_vault_id = module.key_vault_test.key_vault_id
}

resource "azurerm_key_vault_key" "key_name" {
  name         = var.key_name
  key_vault_id = module.key_vault_test.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

module "key_vault_test" {
  source                          = "../"
  resource_group_name             = data.azurerm_resource_group.rg.name
  name                            = var.name
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  sku_name                        = var.sku_name
  subnet_name                     = var.subnet_name
  virtual_network_name            = var.virtual_network_name
  tenant_id                       = var.tenant_id
  #access_policies                 = var.access_policies
  network_acls                    = var.network_acls
  #secret_name                     = var.secret_name
  #certificate_name                = var.certificate_name
  #key_name                        = var.key_name
  #log_analytics_workspace_id       = var.log_analytics_workspace_id
  #diagnostics_storage_account_name = var.diagnostics_storage_account_name
  #kv_additional_tags               = var.additional_tags
  
  #depends_on = [
   # azurerm_resource_group.test
  #]
}
  
 
