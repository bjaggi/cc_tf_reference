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

variable "service_accounts" {
  type = map(object({
    display_name = string
    role_definitions = list(object({
      role_name   = string
      crn_pattern = string
    }))
  }))
}
