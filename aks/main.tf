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

resource "azurerm_log_analytics_workspace" "this" {
  count = var.enable_oms_agent ? 1 : 0

  name                = "law-${var.dns_prefix}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "this" {
  count = var.enable_oms_agent ? 1 : 0

  solution_name         = "Containers"
  workspace_resource_id = azurerm_log_analytics_workspace.this.0.id
  workspace_name        = azurerm_log_analytics_workspace.this.0.name
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  node_resource_group = data.azurerm_resource_group.rg.name
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges != [] ? var.api_server_authorized_ip_ranges : null
  private_cluster_enabled         = var.private_cluster_enabled

  default_node_pool {
    name            = "default"
    vm_size         = var.default_node_pool_vm_size
    os_disk_size_gb = var.default_node_pool_os_disk_size_gb
    node_count      = var.default_node_pool_node_count
    vnet_subnet_id  = var.default_node_pool_vnet_subnet_id != "" ? var.default_node_pool_vnet_subnet_id : null
    tags            = var.tags
  }


  dynamic linux_profile {
    for_each = var.linux_profile
    content {
      admin_username = var.linux_profile.admin_username
      ssh_key {
        key_data = var.linux_profile.admin_public_key
      }
    }
  }

  dynamic service_principal {
    for_each = var.service_principal.client_id != "" ? ["present"] : []
    content {
      client_id     = var.service_principal.client_id
      client_secret = var.service_principal.client_secret
    }
  }

  dynamic identity {
    for_each = var.service_principal.client_id == "" ? ["present"] : []
    content {
      type = "SystemAssigned"
    }
  }

  dynamic network_profile {
    for_each = var.network_profile != {} ? ["present"] : []
    content {
      network_plugin        = lookup(var.network_profile, "plugin", "kubenet")
      network_policy        = lookup(var.network_profile, "policy", null)
      dns_service_ip        = lookup(var.network_profile, "dns_service_ip", null)
      docker_bridge_cidr    = lookup(var.network_profile, "docker_bridge_cidr", null)
      outbound_type         = lookup(var.network_profile, "outbound_type", null)
      pod_cidr              = lookup(var.network_profile, "pod_cidr", null)
      service_cidr          = lookup(var.network_profile, "service_cidr", null)
      load_balancer_profile {
        managed_outbound_ip_count = lookup(var.network_profile, "egress_ip_count", 1)
      }
    }
  }

  role_based_access_control {
    enabled = false
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = var.enable_kube_dashboard
    }

    dynamic oms_agent {
      for_each = var.enable_oms_agent ? ["present"] : []
      content {
        enabled                    = var.enable_oms_agent
        log_analytics_workspace_id = azurerm_log_analytics_workspace.this.0.id
      }
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }

  tags = var.tags
}
