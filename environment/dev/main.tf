
module "create-kafka-topics" {
    source = "../../modules/kafka-topics-rbac"
    kafka_api_secret = var.kafka_api_secret
    kafka_api_key = var.kafka_api_key
    topics = var.topics
    
    confluent_cloud_api_key = var.confluent_cloud_api_key
    confluent_cloud_api_secret = var.confluent_cloud_api_secret
    env_confluentPS_id = var.env_confluentPS_id
    cluster_confluentPS_id = var.cluster_confluentPS_id
    service_account_list = var.service_account_list
    topics_rbac = var.topics_rbac

}


