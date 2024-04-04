import json
import http.client
import base64
import logging

# Configure the logging
logging.basicConfig(filename='delete-topic.log', level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')

def get_topic_list(config):
    """Function to get the list of topics"""
    conn = http.client.HTTPSConnection(config["CLSTR_REST_URL"])
    headers = {
        'Authorization': "Basic " + base64.b64encode((config["API_KEY"] + ":" + config["API_SECRET"]).encode()).decode()
    }
    conn.request("GET", f"/kafka/v3/clusters/{config['CLSTR_ID']}/topics", headers=headers)
    res = conn.getresponse()
    data = res.read()
    topic_list = json.loads(data.decode("utf-8"))
    return topic_list["data"]

def delete_topics(config, topics, excluded_topics):
    """Function to delete the specified topics"""
    conn = http.client.HTTPSConnection(config["CLSTR_REST_URL"])
    headers = {
        'Authorization': "Basic " + base64.b64encode((config["API_KEY"] + ":" + config["API_SECRET"]).encode()).decode()
    }
    for topic in topics:
        # Check if the topic is in the excluded topics list
        if topic['topic_name'] in excluded_topics:
            logging.info(f"Skipping topic {topic['topic_name']} (excluded)")
            continue

        topic_url = f"/kafka/v3/clusters/{config['CLSTR_ID']}/topics/{topic['topic_name']}"
        conn.request("DELETE", topic_url, headers=headers)
        res = conn.getresponse()
        data = res.read()
        logging.info(f"Deleted topic {topic['topic_name']}: {data.decode('utf-8')}")

def main():
    # Read the configuration from a file
    with open("config-delete.json") as config_file:
        config = json.load(config_file)

    # Get the list of topics
    topic_list = get_topic_list(config)

    # Read the excluded topics from a file
    with open("excluded-topics.json") as excluded_topics_file:
        excluded_topics = json.load(excluded_topics_file)

    # Delete the topics
    delete_topics(config, topic_list, excluded_topics)

if __name__ == "__main__":
    main()
