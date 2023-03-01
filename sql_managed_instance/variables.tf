variable "environment" {
  description = "Prod or Non-Prod or Dev etc"
}

variable "workload" {
  description = "Name of the application or workload"
}

variable "sql_mi_admin" {
  description = "Name of the SQL MI default admin"
}

variable "sql_mi_license" {
  description = "Possible values are LicenseIncluded and BasePrice."
}

variable "sql_mi_name" {
  description = "Name of the SQL MI being created"
}

variable "sql_mi_sku" {
  description = "SKU name for the SQL MI. Valid values include GP_Gen4, GP_Gen5, GP_Gen8IM, GP_Gen8IH, BC_Gen4, BC_Gen5, BC_Gen8IM or BC_Gen8IH."
}

variable "primary_resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the SQL MI."
}

variable "secondary_resource_group_name" {
  type        = string
  description = "The name of the resource group in which the failover SQL MI will be created."
}

variable "sql_mi_vcore" {
  description = "VCores needed for the SQL MI (in number). Values can be 8, 16, or 24 for Gen4 SKUs, or 4, 8, 16, 24, 32, 40, 64, or 80 for Gen5 SKUs."
}

variable "sql_mi_storage_size" {
  description = "Size of the SQL MI Storage in GB (in number)"
}

variable "primary_vnet_name" {
  description = "Name of the VNET where primary MI will be deployed"
}

variable "primary_subnet_name" {
  description = "Name of the subnet where primary MI will be deployed"
}

variable "secondary_vnet_name" {
  description = "Name of the VNET where secondary MI will be deployed"
}

variable "secondary_subnet_name" {
  description = "Name of the subnet where secondary MI will be deployed"
}

variable "dns_zone_partner_id" {
  description = "The ID of the SQL Managed Instance which will share the DNS zone. This is a prerequisite for creating an azurerm_sql_managed_instance_failover_group"
  default     = null
}

variable "storage_account_type" {
  description = "Possible values are GRS, LRS and ZRS. The default value is GRS."
  default     = "GRS"
}

variable "identity" {
  description = "Specifies the type of Managed Service Identity that should be configured on this SQL Managed Instance. Possible values are SystemAssigned, UserAssigned."
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "timezone_id" {
  description = "The TimeZone ID that the SQL Managed Instance will be operating in. Default value is UTC"
  default     = "UTC"
}

variable "proxy_override" {
  description = "Specifies how the SQL Managed Instance will be accessed. Default value is Default. Valid values include Default, Proxy, and Redirect."
  default     = "Default"
}

variable "minimum_tls_version" {
  description = "The Minimum TLS Version. Default value is 1.2 Valid values include 1.0, 1.1, 1.2."
  default     = "1.2"
}

variable "failover_needed" {
  default = false
}

variable "failover_group_name" {

}

variable "key_vault_name" {

}

variable "key_vault_rg_name" {

}

variable "sql_mi_admin_secondary" {
  description = "Name of the SQL MI default admin"
}

variable "sql_mi_license_secondary" {
  description = "Possible values are LicenseIncluded and BasePrice."
  default     = null
}

variable "sql_mi_name_secondary" {
  description = "Name of the SQL MI being created"
}

variable "sql_mi_sku_secondary" {
  description = "SKU name for the SQL MI. Valid values include GP_Gen4, GP_Gen5, GP_Gen8IM, GP_Gen8IH, BC_Gen4, BC_Gen5, BC_Gen8IM or BC_Gen8IH."
  default     = null
}

variable "storage_account_type_secondary" {
  description = "Possible values are GRS, LRS and ZRS. The default value is GRS."
  default     = null
}

variable "sql_mi_vcore_secondary" {
  description = "VCores needed for the SQL MI (in number). Values can be 8, 16, or 24 for Gen4 SKUs, or 4, 8, 16, 24, 32, 40, 64, or 80 for Gen5 SKUs."
  default     = null
}

variable "sql_mi_storage_size_secondary" {
  description = "Size of the SQL MI Storage in GB (in number)"
  default     = null
}
