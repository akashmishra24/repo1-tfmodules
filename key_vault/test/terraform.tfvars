resource_group_name = "azngcpocnp-networking"
virtual_network_name = "azngcpocnp"
subnet_name = "azngcpocnp-private"
workload = "test"
environment = "non-prod"
tenant_id = "7c7fea3f-e205-448e-b10a-701c54916e39"
kv_access_policy = {
    policy1 = {
        key_permissions         = ["Get", "Create", "List", "Delete"]
        secret_permissions      = ["Get", "Set", "List", "Delete","Restore", "Recover"]
        certificate_permissions = ["Get", "Create", "List", "Restore", "Recover", "Delete"]
    }
}
public_network_access_enabled = true
key_name                      = "kv-test-key"
certificate_name              = "certificate"
secret_name                   = "secret"
value                         = "value"
postfix = "test"
