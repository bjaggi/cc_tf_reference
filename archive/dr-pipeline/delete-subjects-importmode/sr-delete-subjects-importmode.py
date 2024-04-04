import http.client
import json
import base64
import logging

# Configure the logging settings
log_file = 'schema_registry_operations.log'
logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Read the authentication details from the config-schema-delete.json file
with open('config-schema-delete.json') as config_file:
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

# Get the list of subjects
conn = http.client.HTTPSConnection(rest_url)
conn.request("GET", "/subjects", headers=headers)
res = conn.getresponse()
data = res.read()

subject_list = json.loads(data.decode("utf-8"))
logging.info("List of Subjects:")
for subject in subject_list:
    logging.info(subject)

# Soft Delete the listed subjects
for subject in subject_list:
    conn.request("DELETE", f"/subjects/{subject}", headers=headers)
    res = conn.getresponse()
    data = res.read()
    logging.info(f"Deleted subject: {subject}")

# Hard Delete the listed subjects
for subject in subject_list:
    conn.request("DELETE", f"/subjects/{subject}?permanent=true", headers=headers)
    res = conn.getresponse()
    data = res.read()
    logging.info(f"Deleted subject: {subject}")

# Change the mode of the schema registry to IMPORT
payload = "{\"mode\":\"IMPORT\"}"
conn.request("PUT", "/mode?force=true", payload, headers=headers)
res = conn.getresponse()
data = res.read()

response = data.decode("utf-8")
logging.info(f"Response: {response}")

# Check the mode of the schema registry
conn.request("GET", "/mode", headers=headers)
res = conn.getresponse()
data = res.read()

mode_response = data.decode("utf-8")
logging.info(f"Schema Registry Mode: {mode_response}")

print(response)

conn.close()
