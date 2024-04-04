terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.35.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "abcd1234"
    container_name       = "terraform-state"
    key                  = "dev.ksql.terraform.tfstate"
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

data "confluent_schema_registry_cluster" "confluentPS_sr" {
  id = var.sr_confluentPS_id
  environment {
    id = var.env_confluentPS_id
  }
}


resource "confluent_service_account" "app-ksql" {
  display_name = "app-aws-ksql"
  description  = "Service account to manage 'confluentPS_ksqldb' ksqlDB cluster"

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_role_binding" "app-ksql-all-topic" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${data.confluent_kafka_cluster.cluster_confluentPS.rbac_crn}/kafka=${data.confluent_kafka_cluster.cluster_confluentPS.id}/topic=*"
}

resource "confluent_role_binding" "app-ksql-all-group" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${data.confluent_kafka_cluster.cluster_confluentPS.rbac_crn}/kafka=${data.confluent_kafka_cluster.cluster_confluentPS.id}/group=*"
}

resource "confluent_role_binding" "app-ksql-all-transactions" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${data.confluent_kafka_cluster.cluster_confluentPS.rbac_crn}/kafka=${data.confluent_kafka_cluster.cluster_confluentPS.id}/transactional-id=*"
}

# ResourceOwner roles above are for KSQL service account to read/write data from/to kafka,
# this role instead is needed for giving access to the Ksql cluster.
resource "confluent_role_binding" "app-ksql-ksql-admin" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "KsqlAdmin"
  crn_pattern = confluent_ksql_cluster.confluentPS_ksqldb.resource_name
}

resource "confluent_role_binding" "app-ksql-schema-registry-resource-owner" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = format("%s/%s", data.confluent_schema_registry_cluster.confluentPS_sr.resource_name, "subject=*")
}

resource "confluent_ksql_cluster" "confluentPS_ksqldb" {
  display_name = "confluentPS_ksqldb"
  csu          = 1
  kafka_cluster {
    id = data.confluent_kafka_cluster.cluster_confluentPS.id
  }
  credential_identity {
    id = confluent_service_account.app-ksql.id
  }
  environment {
    id = data.confluent_environment.env_confluentPS.id
  }
  depends_on = [
    confluent_role_binding.app-ksql-schema-registry-resource-owner
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_api_key" "app-ksqldb-api-key" {
  display_name = "app-ksqldb-api-key"
  description  = "KsqlDB API Key that is owned by 'app-ksql' service account"
  owner {
    id          = confluent_service_account.app-ksql.id
    api_version = confluent_service_account.app-ksql.api_version
    kind        = confluent_service_account.app-ksql.kind
  }

  managed_resource {
    id          = confluent_ksql_cluster.confluentPS_ksqldb.id
    api_version = confluent_ksql_cluster.confluentPS_ksqldb.api_version
    kind        = confluent_ksql_cluster.confluentPS_ksqldb.kind

    environment {
      id = data.confluent_environment.env_confluentPS.id
    }
  }
}
