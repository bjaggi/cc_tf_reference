# Kafka Topic Failover/Promote Script
This script allows you to perform failover or promotion of Kafka topics using the Confluent REST Proxy API. It reads the configuration from a JSON file and uses HTTP requests to interact with the Kafka cluster.

## Prerequisites
Before running the script, ensure that you have the following prerequisites:

Python 3 installed on your system
The required Python packages installed (can be installed via pip):
```
json
logging
base64
requests
```
## Configuration
The script requires a configuration file named primary-config.json to be present in the same directory. The configuration file should have the following structure:
```
{
  "LINK_NAME": "your-cluster-link-name",
  "DEST_CLSTR_ID": "your-destination-cluster-id",
  "DEST_CLSTR_REST_URL": "your-destination-cluster-rest-url",
  "DEST_API_KEY": "your-destination-api-key",
  "DEST_API_SECRET": "your-destination-api-secret",
  "ACTION_TYPE": "failover-or-promote"
}
```
Replace the values with your actual cluster link name, destination cluster ID, destination cluster REST URL, destination API key, destination API secret, and the desired action type (failover or promote).

## Running the Script
To run the script, follow these steps:

Ensure that the `primary-config.json` file is properly configured with your cluster details and the desired action type.

Open a terminal or command prompt and navigate to the directory containing the script.

Run the following command to execute the script:
```
python dr_failover.py
```
The script will perform the specified action (failover or promotion) on the Kafka topics specified in the configuration file.

Check the dr-failover.log file in the same directory for the execution log and any error messages.

> Please exercise caution when using this script, as it can perform critical actions on your Kafka topics. Make sure to review the configuration before running the script.

> Note: If you encounter any issues or errors while running the script, please refer to the troubleshooting section in this README file or contact the script's maintainer for assistance.

## Troubleshooting
If the script fails to connect to the Kafka cluster or encounters authentication errors, ensure that the provided destination cluster ID, cluster REST URL, API key, and API secret in the primary-config.json file are correct.
If the script fails to perform the specified action on the topics or encounters errors during the process, review the logs in the dr-failover.log file for more details. The logs should provide information about any errors encountered during the execution of the script.
