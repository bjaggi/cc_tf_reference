# Delete Kafka Topics Script
This script allows you to delete Kafka topics from a Kafka cluster using the Confluent REST Proxy API. It reads the configuration from a JSON file and uses HTTP requests to interact with the Kafka cluster.

## Prerequisites
Before running the script, ensure that you have the following prerequisites:

Python 3 installed on your system
The required Python packages installed (can be installed via pip):
```
http.client
base64
logging
```
Access to a Kafka cluster with the Confluent REST Proxy API enabled
## Configuration
The script requires a configuration file named config-delete.json to be present in the same directory. The configuration file should have the following structure:
```
{
  "CLSTR_ID": "your-cluster-id",
  "CLSTR_REST_URL": "your-cluster-rest-url",
  "API_KEY": "your-api-key",
  "API_SECRET": "your-api-secret"
}
```
Replace the values with your actual cluster ID, cluster REST URL, API key, and API secret.

## Excluding Topics
If you want to exclude specific topics from deletion, you can provide a list of excluded topics in a separate JSON file named excluded-topics.json. The file should have the following structure:

```
{
  "excluded_topics": ["topic1", "topic2", "topic3"]
}
```
Replace "topic1", "topic2", "topic3" with the actual names of the topics you want to exclude from deletion.

## Running the Script
To run the script, follow these steps:

Ensure that the config-delete.json file is properly configured with your Kafka cluster details.

(Optional) If you want to exclude topics, create the excluded-topics.json file with the list of topics to be excluded.

Open a terminal or command prompt and navigate to the directory containing the script.

Run the following command to execute the script:
```
python delete_topics.py
```
The script will connect to the Kafka cluster, retrieve the list of topics, and delete the specified topics while logging the process.

Check the `delete-topic.log` file in the same directory for the execution log and any error messages.

Please exercise caution when using this script, as it can delete topics from your Kafka cluster. Make sure to double-check your configuration and excluded topics list before running the script.


## Troubleshooting
If the script fails to connect to the Kafka cluster or encounters authentication errors, ensure that the provided cluster ID, cluster REST URL, API key, and API secret in the config-delete.json file are correct.
If the script fails to delete topics or encounters errors during the deletion process, review the logs in the delete-topic.log file for more details. The logs should provide information about any errors encountered during the deletion process.
