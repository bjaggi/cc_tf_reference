provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}
data "confluent_environment" "env_confluentPS" {
  id = var.env_confluentPS_id
}

data "confluent_kafka_cluster" "cluster_confluentPS" {
  id = var.cluster_confluentPS_id
  environment {
    id = var.env_confluentPS_id
  }
}

# RBAC  
// Provisioning Kafka Topics requires access to the REST endpoint on the Kafka cluster
// If Terraform is not run from within the private network, this will not work

module "topic" {
  for_each        = { for topic in var.topics : topic.name => topic }
  source          = "./topic"
  topics = var.topics  
  environment     = data.confluent_environment.env_confluentPS.id
  cluster         = data.confluent_kafka_cluster.cluster_confluentPS.id
  topic           = each.value
  service_account_list = var.service_account_list
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret

  admin_sa        = {
    id = var.kafka_api_key
    secret = var.kafka_api_secret
  }  
}



module "service_account" {
  for_each        = toset(var.service_account_list )
  source          = "./service-account"
  topics = null
  environment     = data.confluent_environment.env_confluentPS.id
  cluster         = data.confluent_kafka_cluster.cluster_confluentPS.id
  
  service_account_list = var.service_account_list
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  topic           = null
  topics_rbac = null
  service_account_name = each.value

  admin_sa        = {
    id = var.kafka_api_key
    secret = var.kafka_api_secret
  }  
    depends_on = [ module.topic ]
}


locals {
  consumer_nestedlist = flatten([
    for topic_name, rbac_object_list in var.topics_rbac : [
      for k1, v1 in rbac_object_list.consumer_sa_list : [
        {
          topic_name = rbac_object_list.topic_name,
          value = rbac_object_list,
          rbac_list = v1
          role_name   = "DeveloperRead"
          all_values = join(".", [rbac_object_list.topic_name],[v1])

        }
      ]
    ]
  ])
}

module "topic_rbac_consumers" {
  #for_each = { for topic_rbac in var.topics_rbac : topic_rbac.topic_name => topic_rbac }
  for_each             = { for o in local.consumer_nestedlist : o.all_values => o }

  source          = "./topic-rbac"
  topics = var.topics  
  environment     = data.confluent_environment.env_confluentPS.id
  cluster         = data.confluent_kafka_cluster.cluster_confluentPS.id
  topic_name =  each.value.topic_name
  topic           = null

  service_account_list = var.service_account_list
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  topics_rbac = var.topics_rbac
  #service_account_name = each.value.ser
  #TODO this is a list
  service_account_name = each.value.rbac_list
  role_name = each.value.role_name

  

  admin_sa        = {
    id = var.kafka_api_key
    secret = var.kafka_api_secret
  }  
  depends_on = [ module.topic , module.service_account ]
}





locals {
  producer_nestedlist = flatten([
    for topic_name, rbac_object_list in var.topics_rbac : [
      for k1, v1 in rbac_object_list.producer_sa_list : [
        {
          topic_name = rbac_object_list.topic_name,
          value = rbac_object_list,
          rbac_list = v1
          role_name   = "DeveloperWrite"
          all_values = join(".", [rbac_object_list.topic_name],[v1])
        }
      ]
    ]
  ])
}

module "topic_rbac_producers" {
  #for_each = { for topic_rbac in var.topics_rbac : topic_rbac.topic_name => topic_rbac }
  for_each             = { for o in local.producer_nestedlist : o.all_values => o }

  source          = "./topic-rbac"
  topics = var.topics  
  environment     = data.confluent_environment.env_confluentPS.id
  cluster         = data.confluent_kafka_cluster.cluster_confluentPS.id
  topic_name =  each.value.topic_name
  topic           = null

  service_account_list = var.service_account_list
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  topics_rbac = var.topics_rbac
  #service_account_name = each.value.ser
  #TODO this is a list
  service_account_name = each.value.rbac_list
  role_name = each.value.role_name

  

  admin_sa        = {
    id = var.kafka_api_key
    secret = var.kafka_api_secret
  }  
  depends_on = [ module.topic , module.service_account ]
}








locals {
  producer_consumer_nestedlist = flatten([
    for topic_name, rbac_object_list in var.topics_rbac : [
      for k1, v1 in rbac_object_list.producer_and_consumer_sa_list : [
        {
          topic_name = rbac_object_list.topic_name,
          value = rbac_object_list,
          rbac_list = v1
          role_name   = "DeveloperManage"
          all_values = join(".", [rbac_object_list.topic_name],[v1])

        }
      ]
    ]
  ])
}

module "topic_rbac_producers_consumers" {
  #for_each = { for topic_rbac in var.topics_rbac : topic_rbac.topic_name => topic_rbac }
  for_each             = { for o in local.producer_consumer_nestedlist : o.all_values => o }

  source          = "./topic-rbac"
  topics = var.topics  
  environment     = data.confluent_environment.env_confluentPS.id
  cluster         = data.confluent_kafka_cluster.cluster_confluentPS.id
  topic_name =  each.value.topic_name
  topic           = null

  service_account_list = var.service_account_list
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  topics_rbac = var.topics_rbac
  #service_account_name = each.value.ser
  #TODO this is a list
  service_account_name = each.value.rbac_list
  role_name = each.value.role_name

  

  admin_sa        = {
    id = var.kafka_api_key
    secret = var.kafka_api_secret
  }  

  depends_on = [ module.topic , module.service_account ]
}