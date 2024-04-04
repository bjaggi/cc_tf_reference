import http.client
import json
import base64
import logging

# Set up logging
logging.basicConfig(filename='invite.log', level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')

# Path to the input file
input_file = "users-email.txt"

# Path to the JSON config file
config_file = "config.json"

# Confluent Cloud API endpoint
api_endpoint = "api.confluent.cloud"

# Read API key and secret from the config file
with open(config_file) as f:
    config = json.load(f)
    api_key = config["API_KEY"]
    api_secret = config["API_SECRET"]

# Set up the HTTP connection
conn = http.client.HTTPSConnection(api_endpoint)
api_auth = base64.b64encode(f"{api_key}:{api_secret}".encode()).decode()

# Set up the headers with basic authentication
headers = {
    'Content-Type': "application/json",
    'Authorization': f"Basic {api_auth}"
}

# Dictionary to store user data
user_accounts = {}

# Loop through each email in the input file
with open(input_file) as f:
    emails = f.read().splitlines()
    for email in emails:
        # Set up the payload with the email and auth type
        payload = {
            "email": email,
            "auth_type": "SSO"
        }
        # Send the POST request
        conn.request("POST", "/iam/v2/invitations", json.dumps(payload), headers)

        # Get the response
        res = conn.getresponse()
        data = res.read()

        # Parse the response JSON
        response_json = json.loads(data.decode("utf-8"))

        # Check if the "user" key exists in the response
        if "user" in response_json:
            # Extract user ID and email from the response
            user_id = response_json["user"]["id"]
            user_email = response_json["email"]

            # Create the user account entry
            user_account = {
                "email": user_email,
                "role_definitions": [
                    {
                        "role_name": "DeveloperRead",
                        "crn_pattern": "crn://confluent.cloud/organization=fff39d13-91b7-444b-baa6-c0007e80e4d5/environment=env-7yyo1p/cloud-cluster=lkc-xm39wk/kafka=lkc-xm39wk/topic=*"
                    },
                    {
                        "role_name": "DeveloperRead",
                        "crn_pattern": "crn://confluent.cloud/organization=fff39d13-91b7-444b-baa6-c0007e80e4d5/environment=env-7yyo1p/cloud-cluster=lkc-xm39wk/kafka=lkc-xm39wk/group=*"
                    },
                    {
                        "role_name": "DataDiscovery",
                        "crn_pattern": "crn://confluent.cloud/organization=fff39d13-91b7-444b-baa6-c0007e80e4d5/environment=env-7yyo1p"
                    }
                ]
            }

            # Add the user account to the dictionary
            user_accounts[user_id] = user_account

        # Log the response data
        response_data = data.decode("utf-8")
        logging.info(response_data)

# Close the connection
conn.close()

# Write user accounts to a JSON file
output_file = "user-accounts.json"
with open(output_file, "w") as f:
    json.dump(user_accounts, f, indent=4)

print(f"User accounts saved to {output_file}")
