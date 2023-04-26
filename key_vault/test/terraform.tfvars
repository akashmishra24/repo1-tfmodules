resource_group_name = "azngcpocnp-networking"
virtual_network_name = "azngcpocnp"
subnet_name = "azngcpocnp-private"
workload = "test"
environment = "non-prod"
tenant_id = "7c7fea3f-e205-448e-b10a-701c54916e39"
kv_access_policy = {
    policy1 = {
        key_permissions         = ["Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "Delete", "Purge"]
        secret_permissions      = ["Get","Create", "Set", "List", "Delete", "Purge"]
        certificate_permissions = ["Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "Delete", "Purge"]
    }
}
public_network_access_enabled = true
key_name                      = "key"
certificate_name              = "certificate"
secret_name                   = "secret"
value                         = "value"
