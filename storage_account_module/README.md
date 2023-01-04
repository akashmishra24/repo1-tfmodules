<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_advanced_threat_protection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/advanced_threat_protection) | resource |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) | resource |
| [azurerm_storage_blob.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_queue.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue) | resource |
| [azurerm_storage_share.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_storage_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blobs"></a> [blobs](#input\_blobs) | Map of Storage Blobs | <pre>map(object({<br>    name                   = string<br>    storage_account_name   = string<br>    storage_container_name = string<br>    type                   = string<br>    size                   = number<br>    content_type           = string<br>    source_uri             = string<br>    metadata               = map(any)<br>  }))</pre> | `{}` | no |
| <a name="input_cmk_key_vault"></a> [cmk\_key\_vault](#input\_cmk\_key\_vault) | Key vault variable to enable CMK for Storage account | <pre>object({<br>    key_vault_name     = string # Existing Key vault name<br>    key_vault_rg_name  = string # Existing Key vault resource group name<br>    key_vault_key_name = string<br>  })</pre> | `null` | no |
| <a name="input_containers"></a> [containers](#input\_containers) | Map of Storage Containers | <pre>map(object({<br>    name                  = string<br>    storage_account_name  = string<br>    container_access_type = string # Options: blob, container, private (default)<br>  }))</pre> | `{}` | no |
| <a name="input_file_shares"></a> [file\_shares](#input\_file\_shares) | Map of Storages File Shares | <pre>map(object({<br>    name                 = string<br>    storage_account_name = string<br>    quota                = number<br>  }))</pre> | `{}` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The resource id of log analytics workspace | `string` | `""` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Private Endpoint variable for storage account | <pre>map(object({<br>    storage_account_key   = string<br>    subnet_id             = string # Existing Subnet ID for the Storage account Private endpoint<br>    subresource_name      = string # Some accepted values are "blob", "table", "blob" or "queue" <br>    private_dns_zone_name = string # Existing private DNS zone name<br>    resource_group_name   = string # Existing private DNS zone resource group name<br>  }))</pre> | `{}` | no |
| <a name="input_queues"></a> [queues](#input\_queues) | Map of Storages Queues | <pre>map(object({<br>    name                 = string<br>    storage_account_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the storage account | `string` | n/a | yes |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | Map of storage accouts which needs to be created in a resource group | <pre>map(object({<br>    name                                 = string<br>    sku                                  = optional(string)<br>    account_kind                         = optional(string)       # StorageV2, by default<br>    access_tier                          = optional(string)       # Inputs must be either Hot or Cold<br>    managed_identity_type                = optional(string)       # The type of Managed Identity which should be assigned to the Storage account. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`. Defaults to `SystemAssigned`<br>    managed_identity_ids                 = optional(list(string)) # A list of User Managed Identity ID's which should be assigned to the Storage account.<br>    enable_large_file_share              = optional(bool)<br>    public_network_access_enabled        = optional(bool)<br>    blob_retention_days                  = optional(number) # Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `30`<br>    container_soft_delete_retention_days = optional(number) # Specifies the number of days that the container should be retained, between `1` and `365` days. Defaults to `30`<br>    change_feed_retention_in_days        = optional(number) # Specifies the duration of change feed events retention in days. The possible values are between 1 and 146000 days (400 years) Defaults to `30`<br>    network_rules = optional(object({<br>      bypass                     = list(string) # (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.<br>      default_action             = string       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.<br>      ip_rules                   = list(string) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.<br>      virtual_network_subnet_ids = list(string) # (Optional) One or more Subnet ID's which should be able to access this Key Vault.<br>    }))<br>    lifecycles = optional(list(object({ # Manages an Azure Storage Account Management Policy.<br>      prefix_match               = set(string)<br>      tier_to_cool_after_days    = number<br>      tier_to_archive_after_days = number<br>      delete_after_days          = number<br>      snapshot_delete_after_days = number<br>    })))<br>  }))</pre> | `{}` | no |
| <a name="input_tables"></a> [tables](#input\_tables) | Map of Storage Tables | <pre>map(object({<br>    name                 = string<br>    storage_account_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags of the SA in addition to the resource group tag. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_blob_ids"></a> [blob\_ids](#output\_blob\_ids) | ID of the storage account blob |
| <a name="output_blob_names"></a> [blob\_names](#output\_blob\_names) | Name of the storage account blob |
| <a name="output_blob_urls"></a> [blob\_urls](#output\_blob\_urls) | URL of the storage account blob |
| <a name="output_container_ids"></a> [container\_ids](#output\_container\_ids) | ID of the storage account container |
| <a name="output_container_names"></a> [container\_names](#output\_container\_names) | Name of the storage account container |
| <a name="output_file_share_ids"></a> [file\_share\_ids](#output\_file\_share\_ids) | ID of the storage account file share |
| <a name="output_file_share_names"></a> [file\_share\_names](#output\_file\_share\_names) | Name of the storage account file share |
| <a name="output_file_share_urls"></a> [file\_share\_urls](#output\_file\_share\_urls) | URL of the storage account file share |
| <a name="output_private_ips"></a> [private\_ips](#output\_private\_ips) | Private IP of the storage accounts |
| <a name="output_queue_ids"></a> [queue\_ids](#output\_queue\_ids) | ID of the storage account queue |
| <a name="output_queue_names"></a> [queue\_names](#output\_queue\_names) | Name of the storage account queue |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | Name of the storage accounts resource group |
| <a name="output_sa_access_tier"></a> [sa\_access\_tier](#output\_sa\_access\_tier) | Storage account access tier |
| <a name="output_sa_account_kind"></a> [sa\_account\_kind](#output\_sa\_account\_kind) | Storage account kind |
| <a name="output_sa_account_replication_type"></a> [sa\_account\_replication\_type](#output\_sa\_account\_replication\_type) | Storage account replication type |
| <a name="output_sa_account_tier"></a> [sa\_account\_tier](#output\_sa\_account\_tier) | Storage account tier |
| <a name="output_sa_advanced_threat_protection"></a> [sa\_advanced\_threat\_protection](#output\_sa\_advanced\_threat\_protection) | Storage account advanced threat protection ID |
| <a name="output_sa_diagnostics_target_resource_id"></a> [sa\_diagnostics\_target\_resource\_id](#output\_sa\_diagnostics\_target\_resource\_id) | Storage account diagnostics ID |
| <a name="output_sa_https_traffic"></a> [sa\_https\_traffic](#output\_sa\_https\_traffic) | Storage account HTTPS traffic |
| <a name="output_sa_ids"></a> [sa\_ids](#output\_sa\_ids) | ID of the storage accounts |
| <a name="output_sa_ids_map"></a> [sa\_ids\_map](#output\_sa\_ids\_map) | Name & ID of the storage accounts |
| <a name="output_sa_names"></a> [sa\_names](#output\_sa\_names) | Name of the storage accounts |
| <a name="output_sa_primary_blob_connection_string"></a> [sa\_primary\_blob\_connection\_string](#output\_sa\_primary\_blob\_connection\_string) | Storage account primary blob connection string |
| <a name="output_sa_primary_blob_endpoint"></a> [sa\_primary\_blob\_endpoint](#output\_sa\_primary\_blob\_endpoint) | Storage account primary blob endpoint |
| <a name="output_sa_primary_connection_string"></a> [sa\_primary\_connection\_string](#output\_sa\_primary\_connection\_string) | Storage account primary connection string |
| <a name="output_sa_primary_file_endpoint"></a> [sa\_primary\_file\_endpoint](#output\_sa\_primary\_file\_endpoint) | Storage account primary file endpoint |
| <a name="output_sa_primary_queue_endpoint"></a> [sa\_primary\_queue\_endpoint](#output\_sa\_primary\_queue\_endpoint) | Storage account primary queue endpoint |
| <a name="output_sa_primary_table_endpoint"></a> [sa\_primary\_table\_endpoint](#output\_sa\_primary\_table\_endpoint) | Storage account primary table endpoint |
| <a name="output_sa_tls_version"></a> [sa\_tls\_version](#output\_sa\_tls\_version) | Storage account TLS version |
| <a name="output_table_ids"></a> [table\_ids](#output\_table\_ids) | ID of the storage account table |
| <a name="output_table_names"></a> [table\_names](#output\_table\_names) | Name of the storage account table |
<!-- END_TF_DOCS -->