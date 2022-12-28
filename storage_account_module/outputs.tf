output "sa_names" {
  value       = [for x in azurerm_storage_account.this : x.name]
  description = "Name of the storage accounts"
}

output "resource_group" {
  value       = [for x in azurerm_storage_account.this : x.resource_group_name]
  description = "Name of the storage accounts resource group"
}

output "sa_ids" {
  value       = [for x in azurerm_storage_account.this : x.id]
  description = "ID of the storage accounts"
}

output "sa_ids_map" {
  value       = { for x in azurerm_storage_account.this : x.name => x.id }
  description = "Name & ID of the storage accounts"
}

output "container_ids" {
  value       = [for c in azurerm_storage_container.this : c.id]
  description = "ID of the storage account container"
}

output "container_names" {
  value       = [for c in azurerm_storage_container.this : c.name]
  description = "Name of the storage account container"
}

output "blob_ids" {
  value       = [for b in azurerm_storage_blob.this : b.id]
  description = "ID of the storage account blob"
}

output "blob_names" {
  value       = [for b in azurerm_storage_blob.this : b.name]
  description = "Name of the storage account blob"
}

output "blob_urls" {
  value       = [for b in azurerm_storage_blob.this : b.url]
  description = "URL of the storage account blob"
}

output "queue_ids" {
  value       = [for q in azurerm_storage_queue.this : q.id]
  description = "ID of the storage account queue"
}

output "queue_names" {
  value       = [for q in azurerm_storage_queue.this : q.name]
  description = "Name of the storage account queue"
}

output "file_share_ids" {
  value       = [for f in azurerm_storage_share.this : f.id]
  description = "ID of the storage account file share"
}

output "file_share_names" {
  value       = [for f in azurerm_storage_share.this : f.name]
  description = "Name of the storage account file share"
}

output "file_share_urls" {
  value       = [for f in azurerm_storage_share.this : f.url]
  description = "URL of the storage account file share"
}

output "table_ids" {
  value       = [for t in azurerm_storage_table.this : t.id]
  description = "ID of the storage account table"
}

output "table_names" {
  value       = [for t in azurerm_storage_table.this : t.name]
  description = "Name of the storage account table"
}

output "private_ips" {
  value       = { for pe in azurerm_private_endpoint.this : pe.name => pe.private_service_connection[0].private_ip_address }
  description = "Private IP of the storage accounts"
}

output "sa_primary_blob_connection_string" {
  value       = { for x in azurerm_storage_account.this : x.name => x.primary_blob_connection_string }
  description = "Storage account primary blob connection string"
  sensitive   = true
}

output "sa_primary_blob_endpoint" {
  value       = { for x in azurerm_storage_account.this : x.name => x.primary_blob_endpoint }
  description = "Storage account primary blob endpoint"
}

output "sa_primary_connection_string" {
  value       = { for x in azurerm_storage_account.this : x.name => x.primary_connection_string }
  description = "Storage account primary connection string"
  sensitive   = true
}

output "sa_primary_file_endpoint" {
  value       = { for x in azurerm_storage_account.this : x.name => x.primary_file_endpoint }
  description = "Storage account primary file endpoint"
}

output "sa_primary_queue_endpoint" {
  value       = { for x in azurerm_storage_account.this : x.name => x.primary_queue_endpoint }
  description = "Storage account primary queue endpoint"
}

output "sa_primary_table_endpoint" {
  value       = { for x in azurerm_storage_account.this : x.name => x.primary_table_endpoint }
  description = "Storage account primary table endpoint"
}

output "sa_diagnostics_target_resource_id" {
  value       = { for x in azurerm_monitor_diagnostic_setting.this : x.name => x.target_resource_id }
  description = "Storage account diagnostics ID"
}

output "sa_advanced_threat_protection" {
  value       = [for x in azurerm_advanced_threat_protection.this : x.target_resource_id]
  description = "Storage account advanced threat protection ID"
}