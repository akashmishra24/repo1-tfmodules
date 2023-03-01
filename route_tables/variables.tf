variable "rt_name" {
  type        = string
  description = "The name of the route table."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the route table."
}

variable "disable_bgp_route_propagation" {
  type        = bool
  default     = true
  description = "Boolean flag which controls propagation of routes learned by BGP on that route table."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the resource."
}

variable "routes" {
  description = "Custom route rules for the Route Table"
  default     = {}
  type        = map(any)
  # next_hop_type = Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None.
  # next_hop_in_ip_address - Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.
}

variable "vnet_name" {
  description = "Name of the VNET where VMs will be deployed"
}

variable "subnet_name" {
  description = "Name of the subnet where VMs will be deployed"
}
