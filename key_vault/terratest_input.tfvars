name                            = "kv-${var.workload}-${data.azurerm_resource_group.rg.location}-${var.environment}"
location                        = "West Europe"
resource_group_name             = "samplerg"
enabled_for_disk_encryption     = "false"
soft_delete_retention_days      = 7
purge_protection_enabled        = "false"
sku_name                        = "standard"
enabled_for_deployment          = "true"
enabled_for_template_deployment = "true"
enable_rbac_authorization       = "false"
public_network_access_enabled   = "false"
network_acls                    = null
