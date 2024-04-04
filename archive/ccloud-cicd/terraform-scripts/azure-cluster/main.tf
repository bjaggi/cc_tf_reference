terraform {
  required_version = ">= 0.14.0"
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.29.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.55.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

data "confluent_environment" "env_confluentPS" {
  id = var.env_confluentPS_id
}


resource "confluent_network" "private-link" {
  display_name     = "Private Link Network"
  cloud            = "AZURE"
  region           = var.region
  connection_types = ["PRIVATELINK"]
  environment {
    id = data.confluent_environment.env_confluentPS.id
  }
}

data "confluent_network" "example_using_id" {
  id = "n-abc123"
  environment {
    id = "env-xyz456"
  }
}

resource "confluent_private_link_access" "azure" {
  display_name = "Azure Private Link Access"
  azure {
    subscription = var.subscription_id
  }
  environment {
    id = data.confluent_environment.env_confluentPS.id
  }
  network {
    id = confluent_network.private-link.id
  }
}

resource "confluent_kafka_cluster" "azure-dedicated-dev" {
  display_name = "kfkazrdev001"
  availability = "SINGLE_ZONE"
  cloud        = confluent_network.private-link.cloud
  region       = confluent_network.private-link.region
  dedicated {
    cku = 1
  }
  environment {
    id = data.confluent_environment.env_confluentPS.id
  }
  network {
    id = confluent_network.private-link.id
  }
}


# https://docs.confluent.io/cloud/current/networking/private-links/azure-privatelink.html
# Set up Private Endpoints for Azure Private Link in your Azure subscription
# Set up DNS records to use Azure Private Endpoints
provider "azurerm" {
  features {
  }
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

locals {
  hosted_zone = length(regexall(".glb", confluent_kafka_cluster.azure-dedicated-dev.bootstrap_endpoint)) > 0 ? replace(regex("^[^.]+-([0-9a-zA-Z]+[.].*):[0-9]+$", confluent_kafka_cluster.azure-dedicated-dev.rest_endpoint)[0], "glb.", "") : regex("[.]([0-9a-zA-Z]+[.].*):[0-9]+$", confluent_kafka_cluster.azure-dedicated-dev.bootstrap_endpoint)[0]
  network_id  = regex("^([^.]+)[.].*", local.hosted_zone)[0]
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet" {
  for_each = var.subnet_name_by_zone

  name                 = each.value
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone" "hz" {
  resource_group_name = data.azurerm_resource_group.rg.name

  name = local.hosted_zone
}

resource "azurerm_private_endpoint" "endpoint" {
  for_each = var.subnet_name_by_zone

  name                = "confluent-${local.network_id}-${each.key}"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg.name

  subnet_id = data.azurerm_subnet.subnet[each.key].id

  private_service_connection {
    name                              = "confluent-${local.network_id}-${each.key}"
    is_manual_connection              = true
    private_connection_resource_alias = lookup(confluent_network.private-link.azure[0].private_link_service_aliases, each.key, "\n\nerror: ${each.key} subnet is missing from CCN's Private Link service aliases")
    request_message                   = "PL"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "hz" {
  name                  = data.azurerm_virtual_network.vnet.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.hz.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "rr" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.hz.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 60
  records = [
    for _, ep in azurerm_private_endpoint.endpoint : ep.private_service_connection[0].private_ip_address
  ]
}

resource "azurerm_private_dns_a_record" "zonal" {
  for_each = var.subnet_name_by_zone

  name                = "*.az${each.key}"
  zone_name           = azurerm_private_dns_zone.hz.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 60
  records = [
    azurerm_private_endpoint.endpoint[each.key].private_service_connection[0].private_ip_address,
  ]
}
