


data "confluent_kafka_cluster" "kafka_cluster" {
  id = var.cluster
  environment {
    id = var.environment
  }
}
 
resource "confluent_kafka_topic" "topic" { 
  kafka_cluster {
    id = data.confluent_kafka_cluster.kafka_cluster.id
  }
  topic_name    = var.topic.name
  partitions_count   = var.topic.partitions

  # Remove the line below as it is not expected in the current context
  
  rest_endpoint = data.confluent_kafka_cluster.kafka_cluster.rest_endpoint
  credentials {
    key    = var.admin_sa.id
    secret = var.admin_sa.secret
  }
  config = var.topic.config
  



  # It is recommended to set lifecycle { prevent_destroy = true } on production instances to prevent accidental topic deletion. 
  # This setting rejects plans that would destroy or recreate the topic, such as attempting to change uneditable attributes (for example, partitions_count).
  lifecycle {
    prevent_destroy = true
  }
}
