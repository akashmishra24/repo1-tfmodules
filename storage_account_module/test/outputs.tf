output "sa_names" {
  value = module.storage_account_test.sa_names
}

output "resource_group" {
  value = module.storage_account_test.resource_group
}

output "sa_ids" {
  value = module.storage_account_test.sa_ids
}

output "sa_ids_map" {
  value = module.storage_account_test.sa_ids_map
}

output "container_ids" {
  value = module.storage_account_test.container_ids
}

output "container_names" {
  value = module.storage_account_test.container_names
}

output "blob_ids" {
  value = module.storage_account_test.blob_ids
}

output "blob_names" {
  value = module.storage_account_test.blob_names
}

output "blob_urls" {
  value = module.storage_account_test.blob_urls
}

output "queue_ids" {
  value = module.storage_account_test.queue_ids
}

output "queue_names" {
  value = module.storage_account_test.queue_names
}

output "file_share_ids" {
  value = module.storage_account_test.file_share_ids
}

output "file_share_names" {
  value = module.storage_account_test.file_share_names
}

output "file_share_urls" {
  value = module.storage_account_test.file_share_urls
}

output "table_ids" {
  value = module.storage_account_test.table_ids
}

output "table_names" {
  value = module.storage_account_test.table_names
}

output "private_ips" {
  value = module.storage_account_test.private_ips
}

output "sa_primary_blob_connection_string" {
  value     = module.storage_account_test.sa_primary_blob_connection_string
  sensitive = true
}

output "sa_primary_blob_endpoint" {
  value = module.storage_account_test.sa_primary_blob_endpoint
}

output "sa_primary_connection_string" {
  value     = module.storage_account_test.sa_primary_connection_string
  sensitive = true
}

output "sa_primary_file_endpoint" {
  value = module.storage_account_test.sa_primary_file_endpoint
}

output "sa_primary_queue_endpoint" {
  value = module.storage_account_test.sa_primary_queue_endpoint
}

output "sa_primary_table_endpoint" {
  value = module.storage_account_test.sa_primary_table_endpoint
}

output "sa_advanced_threat_protection" {
  value = module.storage_account_test.sa_advanced_threat_protection
}

# - Security Control output
output "sa_https_traffic" {
  value = module.storage_account_test.sa_https_traffic
}

output "sa_tls_version" {
  value = module.storage_account_test.sa_tls_version
}

output "sa_access_tier" {
  value = module.storage_account_test.sa_access_tier
}

output "sa_account_kind" {
  value = module.storage_account_test.sa_account_kind
}

output "sa_account_replication_type" {
  value = module.storage_account_test.sa_account_replication_type
}

output "sa_account_tier" {
  value = module.storage_account_test.sa_account_tier
}
