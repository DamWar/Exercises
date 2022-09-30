terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vnet.name}-back-address"
  frontend_port_name             = "${azurerm_virtual_network.vnet.name}-front-pool"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-front-ip"
  http_setting_name              = "${azurerm_virtual_network.vnet.name}-http-settings"
  listener_name                  = "${azurerm_virtual_network.vnet.name}-listener"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet.name}-request-routing"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet.name}-redirect-config"
}

resource "azurerm_resource_group" "rg" {
  name     = "infrastructure-02"
  location = var.region
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg.name
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "nsgRules" {
  for_each = {
    for index, rule in var.nsgRules :
    rule.name => rule
  }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet.name
  address_space       = var.vnet.addressSpace
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnets" {
  for_each = {
    for index, subnet in var.vnet.subnets :
    subnet.name => subnet
  }

  name                 = each.value.name
  address_prefixes     = each.value.addressPrefixes
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  dynamic "delegation" {
    for_each = each.value.name == var.app.subnet ? [1] : []

    content {
      name = "delegation"

      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
      }
    }

  }
}

resource "azurerm_network_interface" "vmNic" {
  name                = "${var.vm.name}-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.vm.name}-ip"
    subnet_id                     = azurerm_subnet.subnets[var.vm.subnet].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm.name
  location              = var.region
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vmNic.id]
  vm_size               = var.vm.tier

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = var.vm.image.publisher
    offer     = var.vm.image.offer
    sku       = var.vm.image.sku
    version   = var.vm.image.version
  }
  storage_os_disk {
    name              = "${var.vm.name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.vm.diskTier
  }

  os_profile {
    computer_name  = var.vm.osProfile.computer_name
    admin_username = var.vm.osProfile.admin_username
    admin_password = var.vm.osProfile.admin_password

  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage.name
  account_tier             = var.storage.pricing.tier
  account_replication_type = var.storage.pricing.replication
  location                 = var.region
  resource_group_name      = azurerm_resource_group.rg.name
}

resource "azurerm_mssql_server" "sqlServer" {
  name                         = var.sql.server.name
  version                      = var.sql.server.version
  administrator_login          = var.sql.server.adminLogin
  administrator_login_password = var.sql.server.adminPassword
  location                     = var.region
  resource_group_name          = azurerm_resource_group.rg.name
}

resource "azurerm_mssql_database" "database" {
  name        = var.sql.database.name
  server_id   = azurerm_mssql_server.sqlServer.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = 1
  sku_name    = var.sql.database.tier
}

resource "azurerm_mssql_database_extended_auditing_policy" "dbBu" {
  database_id                             = azurerm_mssql_database.database.id
  storage_endpoint                        = azurerm_storage_account.storage.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.storage.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = var.sql.database.backupPolicy.retentionDays
}

resource "azurerm_mssql_firewall_rule" "dbRules" {
  for_each = {
    for index, rule in var.sql.rules :
    rule.name => rule
  }

  name             = each.value.name
  server_id        = azurerm_mssql_server.sqlServer.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_storage_container" "container" {
  name                  = "appbu"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

data "azurerm_storage_account_blob_container_sas" "containerSas" {
  connection_string = azurerm_storage_account.storage.primary_connection_string
  container_name    = azurerm_storage_container.container.name
  https_only        = true


  start  = "2022-09-27"
  expiry = "2023-01-01"

  permissions {
    read   = true
    add    = true
    create = false
    write  = false
    delete = true
    list   = true
  }
}

resource "azurerm_service_plan" "appPlan" {
  name                = "${var.app.name}-plan"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  os_type  = "Linux"
  sku_name = var.app.tier
}

resource "azurerm_linux_web_app" "appService" {
  name                = var.app.name
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appPlan.id

  https_only = false

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=tcp:${azurerm_mssql_server.sqlServer.name}.database.windows.net,1433;Persist Security Info=False;User ID=${var.sql.server.adminLogin};Password=${var.sql.server.adminPassword};MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=False;Connection Timeout=30;"
  }

  backup {
    name                = "${var.app.name}-bu"
    enabled             = true
    storage_account_url = "https://${var.storage.name}.blob.core.windows.net/${azurerm_storage_container.container.name}${data.azurerm_storage_account_blob_container_sas.containerSas.sas}"
    schedule {
      frequency_interval = var.app.backup.frequency.interval
      frequency_unit     = var.app.backup.frequency.unit
    }
  }

  site_config {
    application_stack {
      docker_image     = var.app.docker.image
      docker_image_tag = var.app.docker.tag
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnetIntegration" {
  app_service_id = azurerm_linux_web_app.appService.id
  subnet_id      = azurerm_subnet.subnets[var.app.subnet].id
}

resource "azurerm_private_dns_zone" "privateDnsZone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnsZoneLink" {
  name                  = "dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privateDnsZone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "privateEndpointApp" {
  name                = "app-endpoint"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnets[var.privateEndpoint.subnet].id

  private_dns_zone_group {
    name                 = "private-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privateDnsZone.id]
  }

  private_service_connection {
    name                           = "private-endpoint-connection"
    private_connection_resource_id = azurerm_linux_web_app.appService.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  # ip_configuration{
  #   name               = "app-endpoint-ip"
  #   private_ip_address = var.privateEndpoint.app.privateIp
  #   subresource_name   = "sites"
  # }
}

resource "azurerm_private_endpoint" "privateEndpointSql" {
  name                = "sql-endpoint"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnets[var.privateEndpoint.subnet].id

  private_dns_zone_group {
    name                 = "private-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privateDnsZone.id]
  }

  private_service_connection {
    name                           = "private-endpoint-connection"
    private_connection_resource_id = azurerm_mssql_server.sqlServer.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_public_ip" "gatewayIp" {
  name                = "appgateway-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "gateway" {
  name                = "tf-appgateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = azurerm_subnet.subnets[var.gateway.subnet].id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.gatewayIp.id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = ["${var.app.name}.privatelink.azurewebsites.net"]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    host_name             = "${var.app.name}.azurewebsites.net"
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = var.gateway.waf.firewall_mode
    rule_set_type    = var.gateway.waf.rule_set_type
    rule_set_version = var.gateway.waf.rule_set_version
  }
}