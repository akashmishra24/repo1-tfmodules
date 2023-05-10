resource_group_name = "azngcpocnp-networking"
name                = "test-law"
sku                 = "PerGB2018"
key_vault           = "keyvault-test"
retention_in_days   = "30"
las = {
  solution1 = {
    solution_name = "test-solution"
    tags = {
      "Environment" = "Non-prod"
    }
    publisher = "Microsoft"
    product   = "VMInsights"
  },
  solution2 = {
    solution_name = "test-solution2"
    tags = {
      "Environment" = "Non-prod"
    }
    publisher = "Microsoft"
    product   = "ContainerInsights"
  }
}