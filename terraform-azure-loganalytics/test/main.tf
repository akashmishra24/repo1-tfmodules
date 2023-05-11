locals {
  location = "eastus"
}

resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = local.location
}

resource "azurerm_key_vault" "test" {
  name      = var.resource_group_name
  key_vault = var.keyvault
  location  = local.location
}


#---------------------------------------------------------
# Create Log Analytics Workspace
#---------------------------------------------------------

module "loganalytics-test" {
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
