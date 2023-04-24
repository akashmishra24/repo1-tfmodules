

variable "private_zone_id" {
  default = null
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Key Vault"
}

variable "virtual_network_name" {
  type    = string
  default = "app-eastus-vnet"
}

variable "subnet_name" {
  default = "app-eastus-snet"
  type    = string
}

variable "tenant_id" {
  default = {}
}

variable "network_acls" {
  type = object({
    bypass                     = string       # (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
    default_action             = string       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
    ip_rules                   = list(string) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
    virtual_network_subnet_ids = list(string) # (Optional) One or more Subnet ID's which should be able to access this Key Vault.
  })
  description = "Specifies values for Key Vault network access"
  default     = null
}

variable "kv_access_policy" {
  default = {}
}

variable "sku_name" {
  default = "standard"
}

variable "enabled_for_deployment" {
  default = true
}

variable "enabled_for_disk_encryption" {
  default = false
}

variable "enabled_for_template_deployment" {
  default = true
}

variable "public_network_access_enabled" {
  default = false
}

variable "soft_delete_retention_days" {
  default = 7
}

# variable "key_permissions" {
#   # ["Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
#   default = ["Get"]
# }

# variable "secret_permissions" {
#   default = ["Get"]
# }

# variable "storage_permissions" {
#   default = null
# }

# variable "certificate_permissions" {
#   default = null
# }

# variable "application_id" {
#   default = null
# }

variable "private_connection_resource_alias" {
  default = null
}

variable "private_dns_zone_group" {
  default = {}
}

variable "ip_configuration" {
  default = {}
}

variable "kv_key" {
  default = {}
  # key_type - Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, RSA and RSA-HSM.
  # key_size - Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key_type is RSA or RSA-HSM.
  # curve - Specifies the curve to use when creating an EC key. Possible values are P-256, P-256K, P-384, and P-521.
  # key_opts - Possible values include: [decrypt, encrypt, sign, unwrapKey, verify and wrapKey].
}

variable "enable_rbac_authorization" {
  default = false
}

variable "purge_protection_enabled" {
  default = false
}

variable "key_name" {
  description = "The name to set for the key vault key."
  type        = string
  default     = "key1"
}

variable "certificate_name" {
  description = "The name to set for the key vault certificate."
  type        = string
  default     = "certificate1"
}

variable "secret_name" {
  description = "The name to set for the key vault secret."
  type        = string
  default     = "secret1"
}

variable "value" {
  description = "The value to set for the key vault secret."
  type        = string
  default     = "value1"
}

variable "secrets" {
  type        = map(string)
  description = "A map of secrets for the Key Vault"
  default     = {}
}
