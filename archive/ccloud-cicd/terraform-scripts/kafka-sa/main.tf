terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.34.0"
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

data "confluent_kafka_cluster" "cluster_confluentPS" {
  id = var.cluster_confluentPS_id
  environment {
    id = var.env_confluentPS_id
  }
}



resource "confluent_service_account" "confluentPS-sa" {
  for_each     = var.accounts
  display_name = each.key
  description  = each.value.description
}

resource "confluent_api_key" "api_key" {
  for_each = var.accounts

  display_name = "${confluent_service_account.confluentPS-sa[each.key].display_name}-api-key"
  description  = "Kafka API Key that is owned by ${confluent_service_account.confluentPS-sa[each.key].display_name} service account"

  # Set optional `disable_wait_for_ready` attribute (defaults to `false`) to `true` if the machine where Terraform is not run within a private network
  # disable_wait_for_ready = true

  owner {
    id          = confluent_service_account.confluentPS-sa[each.key].id
    api_version = confluent_service_account.confluentPS-sa[each.key].api_version
    kind        = confluent_service_account.confluentPS-sa[each.key].kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.cluster_confluentPS.id
    api_version = data.confluent_kafka_cluster.cluster_confluentPS.api_version
    kind        = data.confluent_kafka_cluster.cluster_confluentPS.kind

    environment {
      id = data.confluent_environment.env_confluentPS.id
    }
  }
}
