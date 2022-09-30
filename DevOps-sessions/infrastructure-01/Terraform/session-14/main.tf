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

data "azurerm_client_config" "current" {}

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
}

resource "azurerm_key_vault" "keyVault" {
  name                       = "damwar-keyvault-tf"
  location                   = var.region
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_linux_web_app.appService.identity.0.principal_id

    key_permissions = []

    secret_permissions = [
      "Get", "List"
    ]

    storage_permissions = []
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

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      docker_image     = var.app.docker.image
      docker_image_tag = var.app.docker.tag
    }
  }
}

resource "azurerm_app_configuration" "appconf" {
  name                = "app-conf-tf"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "confReaderAssignment" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_linux_web_app.appService.identity.0.principal_id
}