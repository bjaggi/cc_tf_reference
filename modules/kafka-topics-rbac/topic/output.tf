
output "example" {
  value = "this should show up in plan, at least until you apply it"
}
output "example2" {
  value = var.topic
}


output "created_topic" {
  value = confluent_kafka_topic.topic
}
