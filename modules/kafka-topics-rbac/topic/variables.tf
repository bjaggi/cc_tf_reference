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
    name     = string
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


