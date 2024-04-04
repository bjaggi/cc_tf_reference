# Confluent cloud environment id  
variable "environment" {
  type = string
}

# Confluent cloud cluster id  
variable "cluster" {
  type = string
}


variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
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

variable "role_name" {
  description = "role name"
  type        = string
  default = ""
}

# Topic definition list 
# variable "topic" {
#   type = object({
#     name     = string
#     partitions = number
#     config   =  map(string)
#     consumer = optional(string)
#     producer = optional(string)
#   })
# }


variable "topic" {
  type = object({
    topic     = string
    partitions = number
    config   =  map(string)
    consumer_sa_list = list(string)
    producer_sa_list = list(string)
    producer_and_consumer_sa_list = list(string) 
  })
}


# Topic definition list 
variable "topics" {
  type = list(object({
    name = string
    partitions = number
    config =  map(string)
    consumer_sa_list = list(string)
    producer_sa_list = list(string)
    producer_and_consumer_sa_list = list(string) 
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

# Service Account Credentials to create the topic ( requires a lower RBAC)
variable "admin_sa" {
  type = object({
    id     = string
    secret = string
  })
}

variable "service_account_list"  {
 type = list(string)
}


