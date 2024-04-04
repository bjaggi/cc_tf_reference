import json
import logging
import base64
import requests

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")

# Create a file handler and set its level and formatter
file_handler = logging.FileHandler("dr-failover.log")
file_handler.setLevel(logging.INFO)
file_handler.setFormatter(formatter)

# Add the file handler to the logger
logger.addHandler(file_handler)


def get_mirror_topic_list(cluster_rest_url, cluster_id, headers, link_name, session):
    """Function to get mirror topics list from Cluster link"""
    get_mirror_topics_url = f"{cluster_rest_url}/kafka/v3/clusters/{cluster_id}/links/{link_name}/mirrors"
    mirror_topics_list = []
    response = session.get(get_mirror_topics_url, headers=headers)
    if response.status_code == 200:
        logger.info("Successfully retrieved Mirror Topics:")
        logger.info(json.dumps(json.loads(response.text), indent=2))
        for topic_element in json.loads(response.text)["data"]:
            mirror_topics_list.append(topic_element["mirror_topic_name"])
    else:
        logger.error(f"Failed to pull topics list ({response.status_code})")
        logger.error("Failure reason: " + response.text)
    return mirror_topics_list


def fail_over_topic(cluster_rest_url, cluster_id, headers, link_name, session, topics_list, action_type):
    """Function to failover mirror topics during a disaster"""
    fail_over_url = f"{cluster_rest_url}/kafka/v3/clusters/{cluster_id}/links/{link_name}/mirrors:{action_type}"
    if not topics_list:
        topics_list = get_mirror_topic_list(cluster_rest_url, cluster_id, headers, link_name, session)
    json_payload = dict(mirror_topic_names=topics_list)
    logger.info("Request Payload: " + json.dumps(json_payload))  # Log the request payload
    response = session.post(fail_over_url, headers=headers, data=json.dumps(json_payload))
    logger.info("Response: " + response.text)  # Log the response
    if response.status_code == 200:
        logger.info(json.dumps(json.loads(response.text), indent=2))
        logger.info(f"Successfully completed action: {action_type} for topics: {','.join(map(str, topics_list))}")
    else:
        logger.error(f"Failover for topics failed ({response.status_code})")
        logger.error("Failure reason: " + response.text)


def main():
    # Read the configuration from a file
    with open("primary-config.json") as config_file:
        config = json.load(config_file)

    cluster_link_name = config["LINK_NAME"]
    destination_cluster_id = config["DEST_CLSTR_ID"]
    destination_rest_url = config["DEST_CLSTR_REST_URL"]
    destination_api_key = config["DEST_API_KEY"]
    destination_api_secret = config["DEST_API_SECRET"]
    action_type = config["ACTION_TYPE"].lower()

    # Validating action type
    valid_actions = ['failover', 'promote', 'pause', 'resume']
    if action_type not in valid_actions:
        logger.error("Invalid action. Use one of: " + ",".join(valid_actions))
        return

    destination_api_auth = base64.b64encode(f"{destination_api_key}:{destination_api_secret}".encode()).decode()
    destination_headers = {
        "content-type": "application/json",
        "Authorization": f"Basic {destination_api_auth}"
    }

    with requests.session() as session:
        topics_list = get_mirror_topic_list(destination_rest_url, destination_cluster_id, destination_headers,
                                            cluster_link_name, session)
        fail_over_topic(
            headers=destination_headers,
            cluster_rest_url=destination_rest_url,
            cluster_id=destination_cluster_id,
            link_name=cluster_link_name,
            session=session,
            topics_list=topics_list,
            action_type=action_type
        )

        # Save the result to a JSON file
        result = []
        for topic_element in topics_list:
            result.append(topic_element)

        with open('topics-list.json', 'w') as file:
            json.dump(result, file, indent=2)

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
    main()
