variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}


variable "env_suncor_id" {
  description = "Confluent Environment ID)"
  type        = string
}

variable "cluster_suncor_id" {
  description = "Confluent Cluster suncor ID"
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

variable "user_accounts" {
  type = map(object({
    email = string
    role_definitions = list(object({
      role_name   = string
      crn_pattern = string
    }))
  }))
}
