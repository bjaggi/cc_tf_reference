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

provider "confluent" {
  # https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations
  alias = "kafka"

  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret

  kafka_id            = data.confluent_kafka_cluster.cluster_suncor.id
  kafka_rest_endpoint = data.confluent_kafka_cluster.cluster_suncor.rest_endpoint
  kafka_api_key       = var.kafka_api_key
  kafka_api_secret    = var.kafka_api_secret
}

data "confluent_environment" "env_suncor" {
  id = var.env_suncor_id
}

data "confluent_kafka_cluster" "cluster_suncor" {
  id = var.cluster_suncor_id
  environment {
    id = var.env_suncor_id
  }
}


data "confluent_user" "user_email" {
  for_each = var.user_accounts
  email    = each.value.email
}


locals {
  roles = flatten([
    for account_name, account in var.user_accounts : [
      for role in account.role_definitions : {
        account_name = account_name
        role         = role
      }
    ]
  ])
}

resource "confluent_role_binding" "application-role-binding" {
  for_each = {
    for pair in local.roles :
    "${pair.account_name}_${pair.role.role_name}_${pair.role.crn_pattern}" => {
      principal   = "User:${data.confluent_user.user_email[pair.account_name].id}"
      role_name   = pair.role.role_name
      crn_pattern = pair.role.crn_pattern
    }
  }

  principal   = each.value.principal
  role_name   = each.value.role_name
  crn_pattern = each.value.crn_pattern
}
