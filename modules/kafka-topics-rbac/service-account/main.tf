


data "confluent_kafka_cluster" "kafka_cluster" {
  id = var.cluster
  environment {
    id = var.environment
  }
}
 


# RBAC  
resource "confluent_service_account" "customer_service_account" {  
  # count = data.confluent_service_account.existing.id != null ? 0 : 1
   display_name = var.service_account_name   
}
