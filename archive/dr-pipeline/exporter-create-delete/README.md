# Schema Exporter Creation and Deletion
This repository contains two Python scripts to create and delete a schema exporter in the Confluent Cloud Schema Registry. The first script creates the exporter, while the second script deletes it. The scripts use the http.client, json, and base64 libraries to interact with the Schema Registry API.

## Prerequisites
Python 3.x
http.client, json, and base64 libraries
Internet connectivity
## Configuration
Before running the scripts, ensure that you have provided the necessary configuration details in the config-schema-exporter.json file. The configuration file should have the following structure:

Script 1 - Schema Exporter Creation
```
{
  "SR_PIMARY_CLSTR_REST_URL": "psrc-xxxxxx.us-west-2.aws.confluent.cloud",
  "SR_PRIMARY_API_KEY": "zzzzzzzz",
  "SR_PRIMARY_API_SECRET": "vvvvvvvvvvvvvvv",
  "exporter_name": "aws-sr-exporter-pr-dr",
  "subjects": [":*:"],
  "contextType": "NONE",
  "context": "",
  "config": {
    "schema.registry.url": "https://psrc-yyyyyy.us-east-1.aws.confluent.cloud",
    "basic.auth.credentials.source": "USER_INFO",
    "basic.auth.user.info": "xxxxxxx:yyyyyyyyyyyyyyyy"
  }
}
```

- SR_PIMARY_CLSTR_REST_URL: The URL of the primary Schema Registry cluster to connect to.
- SR_PRIMARY_API_KEY: The primary API key for authentication.
- SR_PRIMARY_API_SECRET: The primary API secret for authentication.
- exporter_name: The name of the exporter to be created.
- subjects (optional): An array of subjects to include in the export. If not provided, all subjects will be included.
- contextType (optional): The context type of the exporter. Defaults to "NONE".
- context (optional): The context name of the exporter. Defaults to an empty string.
- config: Configuration parameters for the destination cluster.
- schema.registry.url: The URL of the destination Schema Registry cluster.
- basic.auth.credentials.source: The authentication source. Defaults to "USER_INFO".
- basic.auth.user.info: The user info for authentication.

Script 2 - Schema Exporter Deletion

```
{
  "SR_PIMARY_CLSTR_REST_URL": "pkc-xxxxx.us-west-2.aws.confluent.cloud",
  "SR_PRIMARY_API_KEY": "xxxxxxxx",
  "SR_PRIMARY_API_SECRET": "yyyyyyyyyyyyyy",
  "exporter_name": "aws-sr-exporter-dr-pr"
}
```

- SR_PIMARY_CLSTR_REST_URL: The URL of the primary Schema Registry cluster to connect to.
- SR_PRIMARY_API_KEY: The primary API key for authentication.
- SR_PRIMARY_API_SECRET: The primary API secret for authentication.
- exporter_name: The name of the exporter to be deleted.

## Usage
Ensure that you have the necessary prerequisites and the configuration files are correctly populated.

Save the first script to a file, e.g., schema_exporter_creation.py, and the second script to another file, e.g., `schema_exporter_deletion.py`.

Open a command prompt or terminal and navigate to the directory containing the scripts.

Run the script to create the exporter using the following command:
```
python schema_exporter_creation.py
```

The exporter will be created with the specified configuration, and the script will log the response in the sr_exporter.log file.

To delete the exporter, run the second script using the following command:

```
python schema_exporter_deletion.py
```

The exporter will be paused and then deleted, and the script will print the response to the console.

## Logging
Both scripts utilize the logging module to write log messages to the sr_exporter.log file. The log file contains timestamped entries with log levels, making it easier to troubleshoot and review the scripts' execution.

Please refer to the log file for more information regarding the execution of the scripts and any potential errors.
