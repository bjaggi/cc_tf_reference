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


variable "service_account_name" {
  description = "Service account name"
  type        = string
  default = ""
}


variable "topic_name" {
  description = "Topic name"
  type        = string
  default = ""
}



# variable "topics" {
#   type = map(object({
#     partitions_count = number
#     cleanup_policy   = string
#   }))
# }

# Topic definition list 



# Topic definition list 
variable "topics" {
  type = list(object({
    name = string
    partitions = number
    config =  map(string)
    consumer_sa_list = optional(list(string))
    producer_sa_list = optional(list(string))
    producer_and_consumer_sa_list = optional(list(string))
  }))
  description = "List of Topics. If RBAC enabled producer service account will be configured as DeveloperWrite and consumer will be configured as DeveloperRead."
}

variable "topics_rbac" {
  type = list(object({
    topic_name = string
    producer_sa_list = optional(list(string))
    consumer_sa_list = optional(list(string))
    producer_and_consumer_sa_list = optional(list(string))
  }))
}
variable "service_account_list"  {
 type = list(string)
}



