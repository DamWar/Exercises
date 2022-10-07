variable "region" {
  type = string
}

variable "rg" {
  type = object({
    name = string
  })
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

variable "vm" {
  type = object({
    name      = string
    image     = map(string)
    tier      = string
    diskTier  = string
    subnet    = string
    osProfile = map(string)
  })
}

variable "storage" {
  type = object({
    name = string
    pricing = object({
      tier        = string
      replication = string
    })
  })
}
variable "sql" {
  type = object({
    server = object({
      name          = string
      version       = string
      adminLogin    = string
      adminPassword = string
    })
    database = object({
      name = string
      tier = string
      backupPolicy = object({
        retentionDays = number
      })
    })
    rules = list(object({
      name             = string
      start_ip_address = string
      end_ip_address   = string
      })
    )
  })
}

variable "app" {
  type = object({
    name = string
    plan = object({
      name = string
      tier = string
    })
    nodes = number
    docker = object({
      image = string
      tag   = string
    })
    backup = object({
      frequency = object({
        interval = number
        unit     = string
      })
    })
    subnet = string
  })
}

variable "privateEndpoint" {
  type = object({
    subnet = string
    app = object({
      privateIp = string
    })
  })
}

variable "gateway" {
  type = object({
    name   = string
    subnet = string
    waf = object({
      firewall_mode    = string
      rule_set_type    = string
      rule_set_version = string
    })
  })
}