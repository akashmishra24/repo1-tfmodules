variable "subnets" {
  # type        = map(any)
  default     = {}
  description = "Details of the subnet like name and address prefix"
  #Example
  # subnet_1 = {
  #    name = "subnet-1"
  #    address_prefixes = ["10.1.1.0/24"]

  #     delegation {
  #          name = "managedinstancedelegation"
  #          service_delegation {
  #              name    = "Microsoft.Sql/managedInstances"
  #              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
  #  }
  #}
  #}
}

variable "vnet_address_space" {
  description = "CIDR block/Address space for the VNET"
}

variable "dns_server_ip" {
  description = "DNS Server IP addresses for the VNET"
}

variable "prefix" {
  description = "Prefix to be added to the VNET"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  description = "Location where the resources will be created"
  default     = null
}

variable "ddos_protection_plan" {
  description = "Create an ddos plan - Default is false"
  default     = {}
}

variable "ddos_plan_name" {
  description = "The name of AzureNetwork DDoS Protection Plan"
  default     = "azureddosplan01"
}

variable "firewall_subnet_address_prefix" {
  description = "CIDR block/Address space for the Firewall Subnet"
  default     = null
}

variable "firewall_service_endpoints" {

}

variable "gateway_subnet_address_prefix" {
  description = "CIDR block/Address space for the Gateway Subnet"
  default     = null
}

variable "gateway_service_endpoints" {

}

variable "create_resource_group" {
  default = false
}
