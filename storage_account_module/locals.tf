locals {
  default_tags = {
    env = "test"
  }
  tags = merge(var.tags, local.default_tags)

  default_network_rules = {
    bypass                     = ["None"]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  disable_network_rules = {
    bypass                     = ["None"]
    default_action             = "Allow"
    ip_rules                   = null
    virtual_network_subnet_ids = null
  }

  blobs = {
    for b in var.blobs : b.name => merge({
      type         = "Block"
      size         = 0
      content_type = "application/octet-stream"
      source_file  = null
      source_uri   = null
      metadata     = {}
    }, b)
  }

  key_permissions         = ["Get", "UnwrapKey", "WrapKey"]
  secret_permissions      = ["Get"]
  certificate_permissions = ["Get"]
  storage_permissions     = ["Get"]
}
