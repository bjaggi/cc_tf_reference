output "resource-ids" {
  value = <<-EOT
  Environment ID:   ${confluent_environment.confluentPS-dev.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.azure-dedicated-dev.id}
  Kafka Bootstrap: ${confluent_kafka_cluster.azure-dedicated-dev.bootstrap_endpoint}

 EOT

  sensitive = true
}
