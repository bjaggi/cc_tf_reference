import http.client
import json
import base64
import logging

# Configure the logging settings
log_file = 'schema_registry_mode_change.log'
logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Read the authentication details from the config-sr-mode-readwrite.json file
with open('config-sr-mode-readwrite.json') as config_file:
    config_data = json.load(config_file)

rest_url = config_data["SR_CLSTR_REST_URL"]
api_key = config_data["SR_API_KEY"]
api_secret = config_data["SR_API_SECRET"]

# Create the basic authentication string
api_auth = base64.b64encode(f"{api_key}:{api_secret}".encode()).decode()

# Set up the headers with basic authentication
headers = {
    'Content-Type': "application/json",
    'Authorization': f"Basic {api_auth}"
}

# Change the mode of the schema registry to READWRITE
payload = "{\"mode\":\"READWRITE\"}"

conn = http.client.HTTPSConnection(rest_url)
conn.request("PUT", "/mode?force=true", payload, headers=headers)
res = conn.getresponse()
data = res.read()

response = data.decode("utf-8")
logging.info(f"Response: {response}")

print(response)

conn.close()
