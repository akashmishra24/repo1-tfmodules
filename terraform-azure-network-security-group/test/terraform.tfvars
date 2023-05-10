nsg_rules = {
  name = "nsg1"
  security_rules = [
    {
      name                                         = "sample-nsg"
      description                                  = "Sample NSG"
      priority                                     = 101
      direction                                    = "Outbound"
      access                                       = "Allow"
      protocol                                     = "Tcp"
      source_port_range                            = "*"
      source_port_ranges                           = null #["443","8080","65200-65535"]
      destination_port_range                       = "*"
      destination_port_ranges                      = null # ["8080-8081"]
      source_address_prefix                        = null
      source_address_prefixes                      = null # [ "10.1.0.128/27","10.1.0.32/27" ]        
      destination_address_prefix                   = null
      destination_address_prefixes                 = null # ["AzureMonitor","AzureActiveDirectory","Internet"]
      source_application_security_group_names      = ["asg-first"]
      destination_application_security_group_names = ["asg-second"]
    }
  ]
}
