#-----------------------------------------------------
# Data Sources
#-----------------------------------------------------

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_log_analytics_workspace" "logws" {
  count               = var.log_analytics_workspace_name != null ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = var.logws_rg_name == null ? data.azurerm_resource_group.rg.name : var.logws_rg_name
}

data "azurerm_storage_account" "storeacc" {
  count               = var.storage_account_name != null ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = var.storage_account_rg == null ? data.azurerm_resource_group.rg.name : var.storage_account_rg
}

#-----------------------------------------------------
# AKS Cluster with default node pool
#-----------------------------------------------------

resource "tls_private_key" "ssh" {
  count = var.admin_username == null ? 0 : 1

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_kubernetes_cluster" "this" {
  name                                = var.aks_name
  location                            = data.azurerm_resource_group.rg.location
  resource_group_name                 = data.azurerm_resource_group.rg.name
  dns_prefix                          = var.dns_prefix
  kubernetes_version                  = var.kubernetes_version
  sku_tier                            = var.sku_tier
  private_cluster_enabled             = var.private_cluster_enabled
  private_dns_zone_id                 = var.private_zone_id # var.private_cluster_enabled == true ? azurerm_private_dns_zone.aks_dns.0.id : null
  azure_policy_enabled                = false
  http_application_routing_enabled    = false
  role_based_access_control_enabled   = true
  private_cluster_public_fqdn_enabled = false
  public_network_access_enabled       = false # var.public_network_access_enabled
  open_service_mesh_enabled           = false
  local_account_disabled              = var.local_account_disabled
  workload_identity_enabled           = var.workload_identity_enabled

  default_node_pool {
    name                   = "default"
    node_count             = var.default_node_pool_node_count
    vm_size                = var.default_node_pool_vm_size # "Standard_DS2_v2"
    zones                  = var.default_node_pool_availability_zones
    enable_auto_scaling    = var.default_node_pool_enable_auto_scaling
    min_count              = var.default_node_pool_min_count
    max_count              = var.default_node_pool_max_count
    max_pods               = var.default_node_pool_max_pods
    os_disk_type           = var.default_node_pool_os_disk_type
    enable_host_encryption = var.default_node_pool_enable_host_encryption
    enable_node_public_ip  = var.default_node_pool_enable_node_public_ip
    os_disk_size_gb        = var.default_node_pool_os_disk_size_gb
    type                   = "VirtualMachineScaleSets"
    vnet_subnet_id         = data.azurerm_subnet.snet.id
    node_taints            = var.default_node_pool_node_taints
    node_labels            = var.default_node_pool_node_labels
    tags                   = var.tags
  }

  # dynamic "linux_profile" {
  #   for_each = var.linux_profile != null ? [true] : []
  #   iterator = lp
  #   content {
  #     admin_username = lp.value.username
  #     ssh_key {
  #       key_data = lp.value.ssh_key
  #     }
  #   }
  # }

  dynamic "linux_profile" {
    for_each = var.admin_username == null ? [] : ["linux_profile"]

    content {
      admin_username = var.admin_username

      ssh_key {
        key_data = replace(coalesce(var.public_ssh_key, tls_private_key.ssh[0].public_key_openssh), "\n", "")
      }
    }
  }

  dynamic "windows_profile" {
    for_each = var.windows_profile
    content {
      admin_username = lookup(each.value, "admin_username", "aks-admin")
      admin_password = lookup(each.value, "admin_password", null)
    }
  }

  # service_principal {
  #   client_id     = var.service_principal.client_id != null ? var.service_principal.client_id : null
  #   client_secret = var.service_principal.client_id != null ? var.service_principal.client_secret : null
  # }
  # Either of 'Service Principal' or 'Identity' can exist at a time

  identity {
    type         = var.user_assigned_mi == null ? "SystemAssigned" : "UserAssigned"
    identity_ids = var.user_assigned_mi == null ? null : var.user_assigned_mi
  }

  # dynamic "identity" {
  #   for_each = var.client_id == "" || var.client_secret == "" ? ["identity"] : []

  #   content {
  #     type         = var.identity_type
  #     identity_ids = var.identity_ids
  #   }
  # }

  azure_active_directory_role_based_access_control {
    managed                = true
    tenant_id              = var.tenant_id
    azure_rbac_enabled     = true
    admin_group_object_ids = var.admin_group_object_ids
  }

  dynamic "aci_connector_linux" {
    for_each = var.aci_connector_linux_enabled ? ["aci_connector_linux"] : []

    content {
      subnet_name = var.aci_connector_linux_subnet_name
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway
    content {
      gateway_id   = lookup(var.ingress_application_gateway, "gateway_id", null)
      gateway_name = lookup(var.ingress_application_gateway, "gateway_name", null)
      subnet_cidr  = lookup(var.ingress_application_gateway, "subnet_cidr", null)
      subnet_id    = lookup(var.ingress_application_gateway, "subnet_id", null)
    }
  }

  dynamic "key_management_service" {
    for_each = var.kms_enabled ? ["key_management_service"] : []

    content {
      key_vault_key_id         = var.kms_key_vault_key_id
      key_vault_network_access = var.kms_key_vault_network_access
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    outbound_type      = var.outbound_type
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
  }


  dynamic "oms_agent" {
    for_each = var.oms_agent_log_analytics_workspace_id != null ? [true] : []
    content {
      log_analytics_workspace_id = var.oms_agent_log_analytics_workspace_id
    }
  }

  dynamic "http_proxy_config" {
    for_each = var.aks_http_proxy_settings
    content {
      http_proxy  = var.aks_http_proxy_settings.http_proxy_url
      https_proxy = var.aks_http_proxy_settings.https_proxy_url
      no_proxy    = var.aks_http_proxy_settings.no_proxy_url_list
      trusted_ca  = var.aks_http_proxy_settings.trusted_ca
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = var.auto_scaler_profile
    content {
      balance_similar_node_groups      = auto_scaler_profile.value.balance_similar_node_groups
      expander                         = auto_scaler_profile.value.expander
      max_graceful_termination_sec     = auto_scaler_profile.value.max_graceful_termination_sec
      max_node_provisioning_time       = auto_scaler_profile.value.max_node_provisioning_time
      max_unready_nodes                = auto_scaler_profile.value.max_unready_nodes
      max_unready_percentage           = auto_scaler_profile.value.max_unready_percentage
      new_pod_scale_up_delay           = auto_scaler_profile.value.new_pod_scale_up_delay
      scale_down_delay_after_add       = auto_scaler_profile.value.scale_down_delay_after_add
      scale_down_delay_after_delete    = auto_scaler_profile.value.scale_down_delay_after_delete
      scale_down_delay_after_failure   = auto_scaler_profile.value.scale_down_delay_after_failure
      scan_interval                    = auto_scaler_profile.value.scan_interval
      scale_down_unneeded              = auto_scaler_profile.value.scale_down_unneeded
      scale_down_unready               = auto_scaler_profile.value.scale_down_unready
      scale_down_utilization_threshold = auto_scaler_profile.value.scale_down_utilization_threshold
      empty_bulk_delete_max            = auto_scaler_profile.value.empty_bulk_delete_max
      skip_nodes_with_local_storage    = auto_scaler_profile.value.skip_nodes_with_local_storage
      skip_nodes_with_system_pods      = auto_scaler_profile.value.skip_nodes_with_system_pods
    }
  }

  api_server_access_profile {
    authorized_ip_ranges     = var.public_network_access_enabled == true ? ["0.0.0.0/32"] : null
    subnet_id                = var.public_network_access_enabled == true ? var.subnet_id : null
    vnet_integration_enabled = var.public_network_access_enabled == true ? var.vnet_integration_enabled : null
  }

  dynamic "storage_profile" {
    for_each = var.storage_profile_enabled ? ["storage_profile"] : []

    content {
      blob_driver_enabled         = var.storage_profile_blob_driver_enabled
      disk_driver_enabled         = var.storage_profile_disk_driver_enabled
      disk_driver_version         = var.storage_profile_disk_driver_version
      file_driver_enabled         = var.storage_profile_file_driver_enabled
      snapshot_controller_enabled = var.storage_profile_snapshot_controller_enabled
    }
  }
  dynamic "web_app_routing" {
    for_each = var.web_app_routing == null ? [] : ["web_app_routing"]

    content {
      dns_zone_id = var.web_app_routing.dns_zone_id
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? ["maintenance_window"] : []

    content {
      dynamic "allowed" {
        for_each = var.maintenance_window.allowed

        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = var.maintenance_window.not_allowed

        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }
  tags = var.tags
}

#-----------------------------------------------------
# Additional Node Pool for the Cluster
#-----------------------------------------------------

resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  for_each = var.additional_node_pool

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = each.value.vm_size
  zones                 = each.value.zones
  enable_auto_scaling   = each.value.enable_auto_scaling
  node_count            = each.value.node_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  max_pods              = each.value.max_pods
  os_disk_size_gb       = each.value.os_disk_size_gb
  os_type               = each.value.os_type
  vnet_subnet_id        = each.value.vnet_subnet_id
  node_taints           = each.value.node_taints
  orchestrator_version  = each.value.orchestrator_version

  tags = var.tags
}

#-----------------------------------------------------
# Role Assignments: ACR, KV and Storage Account
#-----------------------------------------------------

resource "azurerm_role_assignment" "aks_acr_role" {
  count = length(var.container_registries)

  scope                = var.container_registries[count.index]
  role_definition_name = "AcrPull"
  principal_id         = var.user_assigned_mi == null ? azurerm_kubernetes_cluster.this.identity.0.principal_id : var.user_assigned_mi
}

resource "azurerm_role_assignment" "aks_storage_role" {
  count = length(var.storage_contributor)

  scope                = var.storage_contributor[count.index]
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.user_assigned_mi == null ? azurerm_kubernetes_cluster.this.identity.0.principal_id : var.user_assigned_mi
}

resource "azurerm_role_assignment" "aks_kv_role" {
  count = length(var.kv_access)

  scope                = var.kv_access[count.index]
  role_definition_name = "Reader"
  principal_id         = var.user_assigned_mi == null ? azurerm_kubernetes_cluster.this.identity.0.principal_id : var.user_assigned_mi
}

#---------------------------------------------------------------
# Monitoring diagnostics for AKS
#---------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "aks-diag" {
  count                      = var.log_analytics_workspace_name != null || var.storage_account_name != null ? 1 : 0
  name                       = lower("${var.aks_name}-diag")
  target_resource_id         = azurerm_kubernetes_cluster.this.id
  storage_account_id         = var.storage_account_name != null ? data.azurerm_storage_account.storeacc.0.id : null
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logws.0.id

  dynamic "log" {
    for_each = var.aks_diag_logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
}
