output "id" {
    value = azurerm_kubernetes_cluster.this.id
}

output "fqdn" {
    value = azurerm_kubernetes_cluster.this.fqdn
}

output "private_fqdn" {
    value = azurerm_kubernetes_cluster.this.private_fqdn
}

output "kube_admin_config" {
    value = azurerm_kubernetes_cluster.this.kube_admin_config
}

output "kube_admin_config_raw" {
    value = azurerm_kubernetes_cluster.this.kube_admin_config_raw
}

output "host" {
    value = azurerm_kubernetes_cluster.this.kube_config.0.host
}

output "username" {
    value = azurerm_kubernetes_cluster.this.kube_config.0.username
}

output "password" {
    value = azurerm_kubernetes_cluster.this.kube_config.0.password
}

output "client_certificate" {
    value = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate
}

output "client_key" {
    value = azurerm_kubernetes_cluster.this.kube_config.0.client_key
}

output "cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate
}

output "kube_config_raw" {
    value = azurerm_kubernetes_cluster.this.kube_config_raw
}

output "node_resource_group" {
    value = azurerm_kubernetes_cluster.this.node_resource_group
}

output "kubelet_identity" {
    value = azurerm_kubernetes_cluster.this.kubelet_identity
}
