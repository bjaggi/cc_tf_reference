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

# Pause the exporter
conn = http.client.HTTPSConnection(rest_url)
pause_url = f"/exporters/{exporter_name}/pause"
conn.request("PUT", pause_url, headers=headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))

# Delete the exporter
delete_url = f"/exporters/{exporter_name}"
conn.request("DELETE", delete_url, headers=headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))
