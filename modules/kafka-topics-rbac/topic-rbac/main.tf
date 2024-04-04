


data "confluent_kafka_cluster" "kafka_cluster" {
  id = var.cluster
  environment {
    id = var.environment
  }
}
 
data "confluent_kafka_topic" "topic" { 
  kafka_cluster {
    id = data.confluent_kafka_cluster.kafka_cluster.id
  }
  topic_name    = var.topic_name
  rest_endpoint = data.confluent_kafka_cluster.kafka_cluster.rest_endpoint
  credentials {
    key    = var.admin_sa.id
    secret = var.admin_sa.secret
  }
}

data "confluent_service_account" "existing" {
  #id = data.confluent_service_account[var.service_account_name].id
  display_name = var.service_account_name
}
# RBAC  
# resource "confluent_service_account" "customer_service_account" {  
#   # count = data.confluent_service_account.existing.id != null ? 0 : 1
#    display_name = var.service_account_name   
# }

# data "confluent_service_account" "existing" {
#   #id = data.confluent_service_account[var.service_account_name].id
#   display_name = var.service_account_name
# }

## Role binding for the Kafka cluster 
resource "confluent_role_binding" "customer_role_binding" {

  principal   = "User:${data.confluent_service_account.existing.id}"
  role_name = var.role_name
  crn_pattern = "${data.confluent_kafka_cluster.kafka_cluster.rbac_crn}/kafka=${data.confluent_kafka_cluster.kafka_cluster.id}/topic=${data.confluent_kafka_topic.topic.topic_name}"
  depends_on = [
    data.confluent_service_account.existing,
    data.confluent_kafka_cluster.kafka_cluster,
    data.confluent_kafka_topic.topic
  ]
}

