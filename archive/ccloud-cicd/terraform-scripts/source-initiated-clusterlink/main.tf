terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.42.0"
    }
  }
  backend "azurerm" {   
    storage_account_name = "kenprodarmstausw2001"   
    container_name = "terraform-state"   
    key = "prod.azure.clusterlink.dr.terraform.tfstate" 
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

data "confluent_kafka_cluster" "source" {
  id = var.source_kafka_cluster_id
  environment {
    id = var.source_kafka_cluster_environment_id
  }
}

data "confluent_kafka_cluster" "destination" {
  id = var.destination_kafka_cluster_id
  environment {
    id = var.destination_kafka_cluster_environment_id
  }
}

resource "confluent_cluster_link" "source-outbound" {
  link_name       = var.cluster_link_name
  link_mode       = "SOURCE"
  connection_mode = "OUTBOUND"
  source_kafka_cluster {
    id            = data.confluent_kafka_cluster.source.id
    rest_endpoint = data.confluent_kafka_cluster.source.rest_endpoint
    credentials {
      key    = var.kafka_source_api_key
      secret = var.kafka_source_api_secret
    }
  }

  destination_kafka_cluster {
    id                 = data.confluent_kafka_cluster.destination.id
    bootstrap_endpoint = data.confluent_kafka_cluster.destination.bootstrap_endpoint
    credentials {
      key    = var.kafka_destination_api_key
      secret = var.kafka_destination_api_secret
    }
  }

  config = {
    "consumer.offset.sync.enable" = "true"
    "auto.create.mirror.topics.enable" = "true"
    "auto.create.mirror.topics.filters" = "{ \"topicFilters\": [ {\"name\": \"*\",  \"patternType\": \"LITERAL\",  \"filterType\": \"INCLUDE\"} ] }\"
  }

  depends_on = [
    confluent_cluster_link.destination-inbound
  ]
}

resource "confluent_cluster_link" "destination-inbound" {
  link_name       = var.cluster_link_name
  link_mode       = "DESTINATION"
  connection_mode = "INBOUND"
  destination_kafka_cluster {
    id            = data.confluent_kafka_cluster.destination.id
    rest_endpoint = data.confluent_kafka_cluster.destination.rest_endpoint
    credentials {
      key    = var.kafka_destination_api_key
      secret = var.kafka_destination_api_secret
    }
  }

  source_kafka_cluster {
    id                 = data.confluent_kafka_cluster.source.id
    bootstrap_endpoint = data.confluent_kafka_cluster.source.bootstrap_endpoint
  }
}
