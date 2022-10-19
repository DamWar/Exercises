variable "region" {
  type = string
}

variable "nsg" {
  type = object({
    name = string
  })
}

variable "nsgRules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "vnet" {
  type = object({
    name         = string
    addressSpace = list(string)
    subnets = list(object({
      name            = string
      addressPrefixes = list(string)
    }))
  })
}

variable "app" {
  type = object({
    name  = string
    tier  = string
    nodes = number
    docker = object({
      image = string
      tag   = string
    })
  })
}