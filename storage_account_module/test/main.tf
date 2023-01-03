locals {
  location = "eastus"
}

resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = local.location
}

# Calling Storage account Module
module "storage_account_test" {
  source              = "../"
  resource_group_name = azurerm_resource_group.test.name
  storage_accounts    = var.storage_accounts
  tags                = var.tags
  containers          = var.containers
  depends_on = [
    azurerm_resource_group.test
  ]
}
