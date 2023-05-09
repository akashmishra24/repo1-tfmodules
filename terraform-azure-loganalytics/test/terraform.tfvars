resource_group_name = "azngcpocnp-networking"
name                = "test-law"
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