# Schema Registry Mode Change
This is a Python script that changes the mode of a Schema Registry to read-write mode. It utilizes the HTTP client library to make API requests and the json and base64 libraries for JSON parsing and base64 encoding/decoding. The script reads the authentication details from a configuration file and sends an API request to the Schema Registry to change the mode.

## Prerequisites
Python 3.x
http.client, json, and base64 libraries
Internet connectivity
## Configuration
Before running the script, make sure to provide the necessary configuration details in the config-sr-mode-readwrite.json file. The configuration file should have the following structure:
```
{
  "SR_CLSTR_REST_URL": "psrc-xxxxx.us-west-2.aws.confluent.cloud",
  "SR_API_KEY": "xxxxxxx",
  "SR_API_SECRET": "yyyyyyyyyyyyyyyy"
}
```
- SR_CLSTR_REST_URL: The URL of the Schema Registry cluster to connect to.
- SR_API_KEY: The API key for authentication.
- SR_API_SECRET: The API secret for authentication.
## Usage
Ensure that you have the necessary prerequisites and the configuration file is correctly populated.

Save the Python script to a file, e.g., schema_registry_mode_change.py.

Open a command prompt or terminal and navigate to the directory containing the script.

Run the script using the following command:
```
python schema_registry_mode_change.py
```
The script will initiate a connection to the Schema Registry and send an API request to change the mode to read-write.

The response will be logged in the schema_registry_mode_change.log file and printed to the console.

Note: Ensure that the script has the required permissions to access the Schema Registry and that the provided authentication details are correct.

## Logging
The script logs its activities and the API response to the schema_registry_mode_change.log file, located in the same directory as the script. The log file contains timestamped entries with log levels, making it easier to troubleshoot and review the script's execution.

Please refer to the log file for more information regarding the script's execution and any potential errors.

## Troubleshooting
If you encounter any issues, make sure you have a stable internet connection and can access the provided Schema Registry cluster URL.

Double-check the correctness of the authentication details (API key and secret) in the configuration file.

Review the log file (schema_registry_mode_change.log) for any error messages or exceptions encountered during script execution.
