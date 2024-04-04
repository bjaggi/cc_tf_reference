# Schema Registry Operations
This script allows you to delete all subjects in the Schema Registry and update its mode to import mode using the Confluent Schema Registry REST API. It reads the configuration from a JSON file and uses HTTP requests to interact with the Schema Registry.

## Prerequisites
Before running the script, ensure that you have the following prerequisites:

Python 3 installed on your system
The required Python packages installed (can be installed via pip):
```
http.client
json
base64
logging
```
## Configuration
The script requires a configuration file named config-schema-delete.json to be present in the same directory. The configuration file should have the following structure:
```
{
  "SR_CLSTR_REST_URL": "your-schema-registry-rest-url",
  "SR_API_KEY": "your-api-key",
  "SR_API_SECRET": "your-api-secret"
}
```
Replace the values with your actual Schema Registry REST URL, API key, and API secret.

## Running the Script
To run the script, follow these steps:

Ensure that the config-schema-delete.json file is properly configured with your Schema Registry details.

Open a terminal or command prompt and navigate to the directory containing the script.

Run the following command to execute the script:
```
python delete_schema_subjects.py
```
The script will connect to the Schema Registry, retrieve the list of subjects, and perform the following actions:

- Soft delete all the subjects.
- Hard delete all the subjects.
- Change the mode of the Schema Registry to import mode.
- Check the mode of the Schema Registry.
- Generate the `schema_registry_operations.log` file in the same directory for the execution log and any error messages.

> Please exercise caution when using this script, as it can delete subjects from your Schema Registry and change its mode. Make sure to double-check your configuration before running the script.

> Note: If you encounter any issues or errors while running the script, please refer to the troubleshooting section in this README file or contact the script's maintainer for assistance.

## Troubleshooting
If the script fails to connect to the Schema Registry or encounters authentication errors, ensure that the provided Schema Registry REST URL, API key, and API secret in the config-schema-delete.json file are correct.
If the script fails to delete subjects or encounters errors during the deletion process, review the logs in the schema_registry_operations.log file for more details. The logs should provide information about any errors encountered during the deletion process.
