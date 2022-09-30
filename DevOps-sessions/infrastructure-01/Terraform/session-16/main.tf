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

resource "azurerm_storage_account" "storage" {
  name                     = var.storage.name
  account_tier             = var.storage.pricing.tier
  account_replication_type = var.storage.pricing.replication
  location                 = var.region
  resource_group_name      = azurerm_resource_group.rg.name
}

resource "null_resource" "azCli" {
  provisioner "local-exec" {
    command = "az storage blob service-properties update --account-name ${var.storage.name} --static-website --404-document 404.html --index-document index.html --only-show-errors"
  }
}