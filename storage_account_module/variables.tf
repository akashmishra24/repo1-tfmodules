variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account"
}

variable "storage_accounts" {
  type = map(object({
    name                                 = string
    sku                                  = optional(string)
    account_kind                         = optional(string)       # StorageV2, by default
    access_tier                          = optional(string)       # Inputs must be either Hot or Cold
    managed_identity_type                = optional(string)       # The type of Managed Identity which should be assigned to the Storage account. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`. Defaults to `SystemAssigned`
    managed_identity_ids                 = optional(list(string)) # A list of User Managed Identity ID's which should be assigned to the Storage account.
    enable_large_file_share              = optional(bool)
    public_network_access_enabled        = optional(bool)
    blob_retention_days                  = optional(number) # Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `30`
    container_soft_delete_retention_days = optional(number) # Specifies the number of days that the container should be retained, between `1` and `365` days. Defaults to `30`
    change_feed_retention_in_days        = optional(number) # Specifies the duration of change feed events retention in days. The possible values are between 1 and 146000 days (400 years) Defaults to `30`
    network_rules = optional(object({
      bypass                     = list(string) # (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.
      default_action             = string       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
      ip_rules                   = list(string) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
      virtual_network_subnet_ids = list(string) # (Optional) One or more Subnet ID's which should be able to access this Key Vault.
    }))
    lifecycles = optional(list(object({ # Manages an Azure Storage Account Management Policy.
      prefix_match               = set(string)
      tier_to_cool_after_days    = number
      tier_to_archive_after_days = number
      delete_after_days          = number
      snapshot_delete_after_days = number
    })))
  }))
  description = "Map of storage accouts which needs to be created in a resource group"
  default     = {}
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The resource id of log analytics workspace"
  default     = ""
}

variable "cmk_key_vault" {
  type = object({
    key_vault_name     = string # Existing Key vault name
    key_vault_rg_name  = string # Existing Key vault resource group name
    key_vault_key_name = string
  })
  description = "Key vault variable to enable CMK for Storage account"
  default = null
}

variable "private_endpoints" {
  type = map(object({
    storage_account_key   = string
    subnet_id             = string # Existing Subnet ID for the Storage account Private endpoint
    subresource_name      = string # Some accepted values are "blob", "table", "blob" or "queue" 
    private_dns_zone_name = string # Existing private DNS zone name
    resource_group_name   = string # Existing private DNS zone resource group name
  }))
  description = "Private Endpoint variable for storage account"
  default     = {}
}

variable "containers" {
  type = map(object({
    name                  = string
    storage_account_name  = string
    container_access_type = string # Options: blob, container, private (default)
  }))
  description = "Map of Storage Containers"
  default     = {}
}

variable "blobs" {
  type = map(object({
    name                   = string
    storage_account_name   = string
    storage_container_name = string
    type                   = string
    size                   = number
    content_type           = string
    source_uri             = string
    metadata               = map(any)
  }))
  description = "Map of Storage Blobs"
  default     = {}
}

variable "queues" {
  type = map(object({
    name                 = string
    storage_account_name = string
  }))
  description = "Map of Storages Queues"
  default     = {}
}

variable "file_shares" {
  type = map(object({
    name                 = string
    storage_account_name = string
    quota                = number
  }))
  description = "Map of Storages File Shares"
  default     = {}
}

variable "tables" {
  type = map(object({
    name                 = string
    storage_account_name = string
  }))
  description = "Map of Storage Tables"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags of the SA in addition to the resource group tag."
  default     = {}
}