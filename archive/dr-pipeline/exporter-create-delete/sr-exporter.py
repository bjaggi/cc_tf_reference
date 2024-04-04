import http.client
import json
import base64
import logging

# Configure logging to write to a file
log_file = 'sr_exporter.log'
logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Read the configuration details from the config-schema-exporter.json file
with open('config-schema-exporter.json') as config_file:
    config_data = json.load(config_file)

rest_url = config_data["SR_PIMARY_CLSTR_REST_URL"]
api_key = config_data["SR_PRIMARY_API_KEY"]
api_secret = config_data["SR_PRIMARY_API_SECRET"]
exporter_name = config_data["exporter_name"]

# Create the basic authentication string
api_auth = base64.b64encode(f"{api_key}:{api_secret}".encode()).decode()

# Set up the headers with basic authentication
headers = {
    'Content-Type': "application/json",
    'Authorization': f"Basic {api_auth}"
}

# Retrieve the subjects, context-type, and context-name from the configuration file
subjects = config_data.get("subjects", [])
context_type = config_data.get("contextType", "CUSTOM")
context_name = config_data.get("context", "User")

# Retrieve the destination cluster information from the configuration file
destination_config = config_data.get("config", {})

# Create the payload for the request
payload = {
    "name": exporter_name,
    "contextType": context_type,
    "context": context_name,
    "config": destination_config
}
payload_json = json.dumps(payload)

# Make a POST request to create the schema exporter
conn = http.client.HTTPSConnection(rest_url)
conn.request("POST", "/exporters", payload_json, headers)
res = conn.getresponse()
data = res.read()

response = data.decode("utf-8")
logging.info(f"Schema exporter creation response: {response}")

conn.close()


# Function to get the config of the created schema exporter
def get_exporter_config():
    conn = http.client.HTTPSConnection(rest_url)
    headers = {
        'Content-Type': "application/json",
        'Authorization': f"Basic {api_auth}"
    }
    conn.request("GET", f"/exporters/{exporter_name}/config", headers=headers)
    res = conn.getresponse()
    data = res.read()
    logging.info(f"Export config response: {data.decode('utf-8')}")
    conn.close()

# Function to check the status of the created schema exporter
def check_exporter_status():
    conn = http.client.HTTPSConnection(rest_url)
    headers = {
        'Content-Type': "application/json",
        'Authorization': f"Basic {api_auth}"
    }
    conn.request("GET", f"/exporters/{exporter_name}/status", headers=headers)
    res = conn.getresponse()
    data = res.read()
    logging.info(f"Export status response: {data.decode('utf-8')}")
    conn.close()

# Call the get_exporter_config() function to get the config of the created schema exporter
get_exporter_config()

# Call the check_exporter_status() function to check the status of the created schema exporter
check_exporter_status()
