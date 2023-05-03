resource_group_name                    = "azngcpocnp-networking"
type                                   = "private"
frontend_subnet_id                     = "/subscriptions/9fa05bf3-35e9-4525-88d2-4ef3180944a6/resourceGroups/azngcpocnp-networking/providers/Microsoft.Network/virtualNetworks/azngcpocnp/subnets/azngcpocnp-private"
frontend_private_ip_address_allocation = "Static"
frontend_private_ip_address            = "100.92.8.101"
lb_sku                                 = "Standard"
location                               = "eastus"
pip_sku                                = "Standard"
name                                   = "lb-aztest"
pip_name                               = "pip-aztest"

remote_port = {
  ssh = ["Tcp", "22"]
}

lb_port = {
  http  = ["80", "Tcp", "80"]
  https = ["443", "Tcp", "443"]
}

lb_probe = {
  http  = ["Tcp", "80", ""]
  http2 = ["Http", "1443", "/"]
}

tags = {
  cost-center = "12345"
  source      = "terraform"
}