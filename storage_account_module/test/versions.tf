terraform {
  required_providers {
    #azuread = "~> 2.31.0"
    azurerm = "~> 3.37.0"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "7b5c7d11-8bc3-4105-9c6f-41222b38b95f"
  client_id       = "0cffc591-20bd-42b4-b2f5-292ba2b04a1d"
  client_secret   = "dhf8Q~rGEflZ24IW6e.lvrShtwHDXxAJjOs_YbbW"
  tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
}