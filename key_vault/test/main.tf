locals {
  location = "eastus"
}

resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = local.location
}

module "key_vault_test" {
  source                          = "../"
  resource_group_name             = azurerm_resource_group.test.name
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
  #log_analytics_workspace_id       = var.log_analytics_workspace_id
  #diagnostics_storage_account_name = var.diagnostics_storage_account_name
  #kv_additional_tags               = var.additional_tags
  
  #depends_on = [
   # azurerm_resource_group.test
  #]
}
  
 
