variable "enable_oms_agent" {
  type    = bool
  default = false
}

variable "private_zone_id" {
  default = null
}

variable "tenant_id" {

}

variable "admin_group_object_ids" {
  default = null
}

variable "virtual_network_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "aks_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "sku_tier" {
  type    = string
  default = "Free"
}

variable "private_cluster_enabled" {
  type    = bool
  default = false
}

variable "default_node_pool_vm_size" {
  description = "Specifies the vm size of the default node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "default_node_pool_os_disk_size_gb" {
  type    = number
  default = 30
}

variable "default_node_pool_node_count" {
  type    = number
  default = 1
}

variable "default_node_pool_availability_zones" {
  description = "Specifies the availability zones of the default node pool" # ["1", "2", "3", "None"]
  default     = null
  type        = list(string)
}

variable "default_node_pool_enable_auto_scaling" {
  description = "(Optional) Whether to enable auto-scaler. Defaults to false."
  type        = bool
  default     = true
}

variable "default_node_pool_enable_host_encryption" {
  description = "(Optional) Should the nodes in this Node Pool have host encryption enabled? Defaults to false."
  type        = bool
  default     = false
}

variable "default_node_pool_enable_node_public_ip" {
  description = "(Optional) Should each node have a Public IP Address? Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "default_node_pool_max_pods" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
  default     = 50
}

variable "default_node_pool_node_labels" {
  description = "(Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g key=value:NoSchedule). Changing this forces a new resource to be created."
  type        = map(any)
  default     = {}
}

variable "default_node_pool_node_taints" {
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in this Node Pool. Changing this forces a new resource to be created."
  type        = list(string)
  default     = []
}

variable "default_node_pool_os_disk_type" {
  description = "(Optional) The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Defaults to Managed. Changing this forces a new resource to be created."
  type        = string
  default     = "Ephemeral"
}

variable "default_node_pool_max_count" {
  description = "(Required) The maximum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be greater than or equal to min_count."
  type        = number
  default     = 3
}

variable "default_node_pool_min_count" {
  description = "(Required) The minimum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be less than or equal to max_count."
  type        = number
  default     = 1
}

variable "service_principal" {
  type    = object({ client_id = string, client_secret = string })
  default = { client_id = "", client_secret = "" }
}

variable "network_plugin" {
  type    = string
  default = "azure"
}

variable "network_policy" {
  type    = string
  default = "azure"
}

variable "dns_service_ip" {

}

variable "docker_bridge_cidr" {

}

variable "outbound_type" {
  default = null
}

variable "pod_cidr" {
  default = null
}

variable "service_cidr" {
  default = null
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "ingress_application_gateway" {
  type    = map(any)
  default = {}
}

variable "auto_scaler_profile" {
  type    = map(any)
  default = {}
}

variable "api_server_access_profile" {
  type    = map(any)
  default = {}
}

variable "aks_http_proxy_settings" {
  type    = map(any)
  default = {}
}

variable "user_assigned_mi" {
  type    = set(string)
  default = null
}

variable "key_vault_secrets_provider" {
  type    = map(any)
  default = {}
}

variable "public_network_access_enabled" {
  type    = bool
  default = false
}

variable "key_vault_name" {
  type    = string
  default = null
}

variable "key_vault_rg_name" {
  type    = string
  default = null
}

variable "acr_rg_name" {
  type    = string
  default = null
}

variable "acr_name" {
  type    = string
  default = null
}

variable "additional_node_pool" {
  default = {}
  type = map(object({
    name                   = string
    zones                  = list(string)
    vm_size                = string
    enable_auto_scaling    = bool
    node_count             = number
    min_count              = number
    max_count              = number
    max_pods               = number
    os_disk_size_gb        = number
    os_type                = string
    vnet_subnet_id         = string
    node_taints            = list(string)
    orchestrator_version   = string
    enable_host_encryption = bool
    enable_node_public_ip  = bool
    # eviction_policy = string # Possible values are Deallocate and Delete
  }))
}

# variable "linux_profile" {
#   description = "Username and ssh key for accessing AKS Linux nodes with ssh."
#   type = object({
#     username = string,
#     ssh_key  = string
#   })
#   default = null
# }

variable "kms_enabled" {
  type        = bool
  description = "(Optional) Enable Azure KeyVault Key Management Service."
  default     = false
  nullable    = false
}

variable "kms_key_vault_key_id" {
  type        = string
  description = "(Optional) Identifier of Azure Key Vault key. When Azure Key Vault key management service is enabled, this field is required and must be a valid key identifier."
  default     = null
}

variable "kms_key_vault_network_access" {
  type        = string
  description = "(Optional) Network Access of Azure Key Vault. Possible values are: `Private` and `Public`."
  default     = "Public"
  validation {
    condition     = contains(["Private", "Public"], var.kms_key_vault_network_access)
    error_message = "Possible values are `Private` and `Public`"
  }
}

variable "dns_zone_name" {
  default = null
  type    = string
}

variable "dns_zone_rg" {
  default = null
  type    = string
}

variable "windows_profile" {
  default = {}
}

variable "vnet_integration_enabled" {
  default = true
}

variable "subnet_id" {
  default = null
}

variable "oms_agent_log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace which the OMS Agent should send data to. if value is null, no agent is deployed."
  type        = string
  default     = null
}

variable "local_account_disabled" {
  type    = bool
  default = true
}

variable "container_registries" {
  description = "List of Azure Container Registry ids where AKS needs pull access."
  type        = list(string)
  default     = []
}

variable "storage_contributor" {
  description = "List of storage account ids where the AKS Identity should have access."
  type        = list(string)
  default     = []
}

variable "kv_access" {
  description = "List of Key Vault ids where the AKS Identity should have access."
  type        = list(string)
  default     = []
}

variable "aci_connector_linux_enabled" {
  description = "Enable Virtual Node pool"
  type        = bool
  default     = false
}

variable "aci_connector_linux_subnet_name" {
  description = "(Optional) aci_connector_linux subnet name"
  type        = string
  default     = null
}

variable "storage_profile_blob_driver_enabled" {
  type        = bool
  description = "(Optional) Is the Blob CSI driver enabled? Defaults to `false`"
  default     = false
}

variable "storage_profile_disk_driver_enabled" {
  type        = bool
  description = "(Optional) Is the Disk CSI driver enabled? Defaults to `true`"
  default     = true
}

variable "storage_profile_disk_driver_version" {
  type        = string
  description = "(Optional) Disk CSI Driver version to be used. Possible values are `v1` and `v2`. Defaults to `v1`."
  default     = "v1"
}

variable "storage_profile_enabled" {
  description = "Enable storage profile"
  type        = bool
  default     = false
  nullable    = false
}

variable "storage_profile_file_driver_enabled" {
  type        = bool
  description = "(Optional) Is the File CSI driver enabled? Defaults to `true`"
  default     = true
}

variable "storage_profile_snapshot_controller_enabled" {
  type        = bool
  description = "(Optional) Is the Snapshot Controller enabled? Defaults to `true`"
  default     = true
}

variable "web_app_routing" {
  type = object({
    dns_zone_id = string
  })
  description = <<-EOT
  object({
    dns_zone_id = "(Required) Specifies the ID of the DNS Zone in which DNS entries are created for applications deployed to the cluster when Web App Routing is enabled."
  })
EOT
  default     = null
}

variable "maintenance_window" {
  type = object({
    allowed = list(object({
      day   = string
      hours = set(number)
    })),
    not_allowed = list(object({
      end   = string
      start = string
    })),
  })
  description = "(Optional) Maintenance configuration of the managed cluster."
  default     = null
}

variable "workload_identity_enabled" {
  description = "Enable or Disable Workload Identity. Defaults to false."
  type        = bool
  default     = false
}

variable "public_ssh_key" {
  type        = string
  description = "A custom ssh key to control access to the AKS cluster. Changing this forces a new resource to be created."
  default     = ""
}

variable "admin_username" {
  type        = string
  description = "The username of the local administrator to be created on the Kubernetes cluster. Set this variable to `null` to turn off the cluster's `linux_profile`. Changing this forces a new resource to be created."
  default     = null
}

variable "log_analytics_workspace_name" {
  description = "The name of log analytics workspace name"
  default     = null
}

variable "storage_account_name" {
  description = "The name of the hub storage account to store logs"
  default     = null
}

variable "aks_diag_logs" {
  description = "Application Gateway Monitoring Category details for Azure Diagnostic setting"
# default     = ["ContainerRegistryRepositoryEvents", "ContainerRegistryLoginEvents"]
}

variable "logws_rg_name" {
  description = "RG name where the Log Analytics Workspace exists"
  default     = null
}

variable "storage_account_rg" {
  description = "RG name where the Storage Account exists"
  default     = null
}
