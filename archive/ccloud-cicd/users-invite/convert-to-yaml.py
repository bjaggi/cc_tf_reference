import json
import yaml

# Path to the JSON file
json_file = "user-accounts.json"

# Read the JSON data
with open(json_file) as f:
    json_data = json.load(f)

# Convert JSON to YAML tfvars format
yaml_data = ""
user_count = len(json_data)
for i, (user_id, user_info) in enumerate(json_data.items()):
    yaml_data += f'"{user_id}" = {{\n'
    yaml_data += f'  email = "{user_info["email"]}"\n'
    yaml_data += "  role_definitions = [\n"
    role_count = len(user_info["role_definitions"])
    for j, role in enumerate(user_info["role_definitions"]):
        yaml_data += "    {\n"
        yaml_data += f'      role_name   = "{role["role_name"]}"\n'
        yaml_data += f'      crn_pattern = "{role["crn_pattern"]}"\n'
        yaml_data += "    }"
        if j != role_count - 1:
            yaml_data += ","
        yaml_data += "\n"
    yaml_data += "  ]\n"
    yaml_data += "}"
    if i != user_count - 1:
        yaml_data += ","
    yaml_data += "\n"

# Path to the output YAML file
yaml_file = "output.tfvars"

# Write YAML data to file
with open(yaml_file, "w") as f:
    f.write(yaml_data)

print(f"JSON data converted to YAML tfvars format and saved to {yaml_file}")
