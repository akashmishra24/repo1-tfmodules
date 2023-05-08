terraform {
  required_version = "1.3.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "9fa05bf3-35e9-4525-88d2-4ef3180944a6"
  tenant_id       = "7c7fea3f-e205-448e-b10a-701c54916e39"
  features {}
}
