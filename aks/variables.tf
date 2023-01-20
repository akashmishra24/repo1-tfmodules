variable "node_resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "sku_tier" {
  type = string
  default = "Free"
}

variable "api_server_authorized_ip_ranges" {
  type    = list(string)
  default = []
}

variable "private_cluster_enabled" {
  type    = bool
  default = false
}

variable "default_node_pool_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "default_node_pool_os_disk_size_gb" {
  type    = number
  default = 30
}

variable "default_node_pool_node_count" {
  type    = number
  default = 1
}

variable "default_node_pool_vnet_subnet_id" {
  type    = string
  default = ""
}

variable "linux_profile" {
  type    = map
  default = {}
}

variable "service_principal" {
  type    = object({client_id = string, client_secret = string})
  default = {client_id = "", client_secret = ""}
}

variable "network_profile" {
  type    = map
  default = {}
}

variable "enable_kube_dashboard" {
  type    = bool
  default = false
}

variable "enable_oms_agent" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map
  default = {}
}
