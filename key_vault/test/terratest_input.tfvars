name                            = "kv-eastus-testing"
location                        = "eastus"
resource_group_name             = "azngcpocnp-networking"
enabled_for_disk_encryption     = "false"
soft_delete_retention_days      = 7
purge_protection_enabled        = "false"
sku_name                        = "standard"
enabled_for_deployment          = "true"
enabled_for_template_deployment = "true"
enable_rbac_authorization       = "false"
public_network_access_enabled   = "false"
key_name                        = "key"
certificate_name                = "certificate"
secret_name                     = "secret"
value                           = "value"
tenant_id                       = "7c7fea3f-e205-448e-b10a-701c54916e39"
network_acls = {
  bypass                     = "AzureServices"                                                                                                                                                                                                                        # (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
  default_action             = "Deny"                                                                                                                                                                                                                                 # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
  ip_rules                   = ["100.5.0.9"]                                                                                                                                                                                                              # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
  virtual_network_subnet_ids = ["/subscriptions/9fa05bf3-35e9-4525-88d2-4ef3180944a6/resourceGroups/azngcpocnp-networking/providers/Microsoft.Network/virtualNetworks/azngcpocnp/subnets/azngcpocnp-public"] # (Optional) One or more Subnet ID's which should be able to access this Key Vault.   
}



access_policies = {
  "accp1" = {
    group_names             = ["test1", "test2"]
    certificate_permissions = ["get", "list"]
    key_permissions         = ["get", "list"]
    secret_permissions      = ["get", "list"]
    storage_permissions     = ["get", "list"]
  }
}
