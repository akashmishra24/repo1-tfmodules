
variable "nsg_prefix" {
  type        = string
  description = "Name of the Network Security Group"
  default     = "test"
}

variable "nsg_rules" {
  #  type = list(object({
  #    name                       = string
  #    priority                   = number
  #    direction                  = string
  #    access                     = string
  #    protocol                   = string
  #    source_port_range          = string
  #    destination_port_range     = string
  #    source_address_prefix      = string
  #    destination_address_prefix = string
  #  }))
  description = "The values for each NSG rule "
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "The name of resource group"
  default     = "azngcpocnp-networking"
}

variable "subnet_id_nsg" {
  description = "Subnet ID that will be associated with the Route Table"
  default     = {}
}

variable "subnet_ids" {

  default = {}
}

variable "workload" {
  default = "webapp"
}

variable "environment" {
  default = "non-prod"
}
