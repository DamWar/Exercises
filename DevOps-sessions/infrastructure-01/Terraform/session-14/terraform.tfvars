region = "westeurope"

nsg = {
  name = "tf-nsg-01"
}

nsgRules = [
  {
    name                       = "rule1"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "rule2"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

vnet = {
  name         = "tf-vnet-01"
  addressSpace = ["10.0.0.0/16"]
  subnets = [
    {
      name            = "resources"
      addressPrefixes = ["10.0.1.0/24"]
    },
    {
      name            = "endpoints"
      addressPrefixes = ["10.0.2.0/24"]
    },
    {
      name            = "gateways"
      addressPrefixes = ["10.0.3.0/24"]
    }
  ]
}

app = {
  name  = "damwar-app-tf"
  tier  = "S1"
  nodes = 2
  docker = {
    image = "nginx"
    tag   = "alpine"
  }
}
