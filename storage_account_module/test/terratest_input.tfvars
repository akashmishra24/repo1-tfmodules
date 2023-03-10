resource_group_name = "tf-strg-acct-testing"

storage_accounts = {
  atstftststorageacct = {
    name         = "atstftststorageacct",
    sku          = "Standard_LRS",
    account_kind = "StorageV2",
    access_tier  = "Hot",
    network_rules = {
      bypass                     = ["None"],
      default_action             = "Allow",
      ip_rules                   = [],
      virtual_network_subnet_ids = []
    },
    managed_identity_type   = "SystemAssigned"
    enable_large_file_share = false,
  }
}

tags = {
  "date" = "01/03/2023"
}

containers = {
  tfTstStorageContainer = {
    name                  = "tftststoragecontainer",
    storage_account_name  = "atstftststorageacct",
    container_access_type = "container"
  }
}
