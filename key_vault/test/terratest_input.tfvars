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
tenant_id                       = "7c7fea3f-e205-448e-b10a-701c54916e39"
network_acls                    = null


access_policies = {
  "accp1" = {
    group_names             = ["test1", "test2"]
    certificate_permissions = ["get", "list"]
    key_permissions         = ["get", "list"]
    secret_permissions      = ["get", "list"]
    storage_permissions     = ["get", "list"]
  }
}
