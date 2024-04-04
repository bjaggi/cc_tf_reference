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

variable "sr_confluentPS_id" {
  description = "Confluent Schema Registry Cluster confluentPS ID"
  type        = string
}
