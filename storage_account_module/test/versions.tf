terraform {
  required_providers {
    #azuread = "~> 2.31.0"
    azurerm = "~> 3.37.0"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "7b5c7d11-8bc3-4105-9c6f-41222b38b95f"
}