variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}


variable "env_confluentPS_id" {
  description = "Confluent Environment ID)"
  type        = string
}

variable "cluster_confluentPS_id" {
  description = "Confluent Cluster confluentPS ID"
  type        = string
}

variable "kafka_api_key" {
  description = "Confluent Cluster API Key"
  type        = string
}

variable "kafka_api_secret" {
  description = "Confluent Cluster API secret"
  type        = string
}

#variable "data_test_topic" {
#  description = "Topic for JDBC connect data"
#  type        = string
#}

variable "topics" {
  type = map(object({
    partitions_count = number
    cleanup_policy   = string
  }))
}
