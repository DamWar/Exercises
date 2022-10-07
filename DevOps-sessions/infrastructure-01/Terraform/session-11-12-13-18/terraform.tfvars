region = "westeurope"

rg = {
  name = "infrastructure-02"
}

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
      name            = "integration"
      addressPrefixes = ["10.0.1.0/24"]
    },
    {
      name            = "resources"
      addressPrefixes = ["10.0.2.0/24"]
    },
    {
      name            = "endpoints"
      addressPrefixes = ["10.0.3.0/24"]
    },
    {
      name            = "gateways"
      addressPrefixes = ["10.0.4.0/24"]
    }
  ]
}

vm = {
  name = "tf-vm-01"
  image = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  tier     = "Standard_DS1_v2"
  diskTier = "Standard_LRS"
  subnet   = "resources"
  osProfile = {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
}

storage = {
  name = "damwarstoragetf"
  pricing = {
    tier        = "Standard"
    replication = "LRS"
  }
}

sql = {
  server = {
    name          = "tf-sql-01"
    version       = "12.0"
    adminLogin    = "4dm1n157r470r"
    adminPassword = "4-v3ry-53cr37-p455w0rd"
  }
  database = {
    name = "tf-sql-01-db-01"
    tier = "S0"
    backupPolicy = {
      retentionDays = 6
    }
  }
  rules = [
    {
      name             = "Endpoints rule"
      start_ip_address = "10.0.2.0"
      end_ip_address   = "10.0.2.255"
    },
    {
      name             = "Integration rule"
      start_ip_address = "10.0.1.0"
      end_ip_address   = "10.0.1.255"
    }
  ]
}

app = {
  name = "damwar-app-tf"
  plan = {
    name = "damwar-app-tf-plan"
    tier = "S1"
  }
  nodes = 2
  docker = {
    image = "nginx"
    tag   = "alpine"
  }
  backup = {
    frequency = {
      interval = 1
      unit     = "Day"
    }
  }
  subnet = "integration"
}

privateEndpoint = {
  subnet = "endpoints"
  app = {
    privateIp = "10.0.2.4"
  }
}

gateway = {
  name   = "tf-appgateway"
  subnet = "gateways"
  waf = {
    firewall_mode    = "Detection"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}