// terraform.tfvars

# terraform service account API key with organisation Admin role to create ressources in ccloud
confluent_cloud_api_key    = "XX"
confluent_cloud_api_secret = "XX"

kafka_api_key    = "XX"
kafka_api_secret = "XX"


env_confluentPS_id     = "env-7qv2p"
cluster_confluentPS_id = "lkc-y316j"




#data_test_topic = "confluentPS-test"
topics = [
  {
    name       = "topic-a"
    partitions = 10
    config = {
      "delete.retention.ms" = "10000000",
      "min.insync.replicas"="1",
      "cleanup.policy"="compact",
      "max.message.bytes"= "100"
    }
  },
  {
    name       = "topic-b"
    partitions = 10
    config = {
      "delete.retention.ms" = "10000000",
      "min.insync.replicas"="1",
      "cleanup.policy"="compact",
      "max.message.bytes"= "100"
    } 
  }
]

service_account_list = ["producer-sa" , "producer2-sa", "producer3-sa", "consumer-sa","consumer2-sa", "producer_consumer_sa","producer_consumer_sa-b"]

topics_rbac = [
  {
    topic_name = "topic-a" , 
    producer_sa_list = ["producer-sa" , "producer3-sa" ],
    consumer_sa_list = ["consumer-sa"],
    producer_and_consumer_sa_list = ["producer_consumer_sa"]
  },
  {
    topic_name = "topic-b" , 
    producer_sa_list = ["producer2-sa", "producer3-sa" ],
    consumer_sa_list = ["consumer-sa", "consumer2-sa"],
    producer_and_consumer_sa_list = ["producer_consumer_sa-b", "producer_consumer_sa"]
  }
]