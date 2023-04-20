locals {
  location = "eastus"
}

resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = local.location
}

module "key_vault_test" {
  source              = "../"
  resource_group_name = azurerm_resource_group.test.name
  #storage_account_ids_map          = module.StorageAccount.sa_ids_map
  name                            = var.name
  #soft_delete_enabled             = var.soft_delete_enabled
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
  #log_analytics_workspace_id       = var.log_analytics_workspace_id
  #diagnostics_storage_account_name = var.diagnostics_storage_account_name
  #kv_additional_tags               = var.additional_tags
  
  #depends_on = [
   # azurerm_resource_group.test
  #]
}
  
 

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A SECRET TO THE KEY VAULT
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = "${var.secret_name}-${var.postfix}"
  value        = "mysecret"
  key_vault_id = azurerm_key_vault.key_vault.id
}

# ---------------------------------------------------------------------------------------------------------------------
#  DEPLOY A KEY TO THE KEY VAULT
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_key_vault_key" "key_vault_key" {
  name         = "${var.key_name}-${var.postfix}"
  key_vault_id = azurerm_key_vault.key_vault.id
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

# ---------------------------------------------------------------------------------------------------------------------
#  DEPLOY A CERTIFICATE TO THE KEY VAULT
#  The example uses a sample pfx file with plain text password to make it easier to test. However, in production modules 
#  should use a more secure mechanisms for transferring these files.
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_key_vault_certificate" "key_vault_certificate" {
  name         = "${var.certificate_name}-${var.postfix}"
  key_vault_id = azurerm_key_vault.key_vault.id

  certificate {
    contents = filebase64("example.pfx")
    password = "password"
  }

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
