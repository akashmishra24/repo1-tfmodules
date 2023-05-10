variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Log Analytics workspace is created"
}

variable "create_resource_group" {
  type    = bool
  default = false
}

variable "location" {
  default = "eastus"
}

############################
# log analytics
############################
variable "name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace"
}

variable "sku" {
  type        = string
  description = "Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018"
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = string
  description = "The workspace data retention in days. Possible values range between 30 and 730"
  default     = 30
}

variable "tags" {
  default = {}
}

variable "las" {
  default = {}
  # Product = "Security","SecurityInsights","AgentHealthAssessment","AzureActivity","SecurityCenterFree","DnsAnalytics","ADAssessment","AntiMalware","ServiceMap","SQLAssessment", "SQLAdvancedThreatProtection", "AzureAutomation", "Containers", "ChangeTracking", "Updates", "VMInsights"
}

variable "key_vault" {
  default = null
}


variable "allow_resource_only_permissions" {
  default     = true
  description = "(Optional) Specifies if the log Analytics Workspace allow users accessing to data associated with resources they have permission to view, without permission to workspace."
}

variable "local_authentication_disabled" {
  default     = false
  description = "(Optional) Specifies if the log Analytics workspace should enforce authentication using Azure AD."
}

variable "daily_quota_gb" {
  description = "(Optional) The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted."
  default     = null
}

variable "internet_ingestion_enabled" {
  description = "(Optional) Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to true"
  default     = true
}

variable "internet_query_enabled" {
  description = "(Optional) Should the Log Analytics Workspace support querying over the Public Internet? Defaults to true."
  default     = true
}

variable "reservation_capacity_in_gb_per_day" {
  description = "(Optional) The capacity reservation level in GB for this workspace. Must be in increments of 100 between 100 and 5000."
  default     = null
}