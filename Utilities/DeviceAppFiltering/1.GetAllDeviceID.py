# Created by David L. (https://github.com/davidlahoz)
# This script uses Kandji's API to retrieve to 2 different JSON files
# the devices "Mac" and "iPhone". # In case that you want to expand to iPad/AppleTV, add other lists. Add devices according to  "platform"
# Created by David Lahoz
import requests
import json
import os

# Load the JSON configuration file
with open('config.json', 'r') as config_file:
    config_data = json.load(config_file)

# Access the variables
subdomain = config_data['subdomain']
api_key = config_data['api_key']

# Script variables
url = f"https://{subdomain}.api.eu.kandji.io/api/v1/devices"


payload={}

headers = {
    'Authorization': f'Bearer {api_key}'
}


response = requests.request("GET", url, headers=headers, data=payload)

with open('export.json', 'w') as outfile:
    json.dump(response.json(), outfile)


#Clean and extract needed data only from the original ListDevices request. Splitted json by platform (Mac/iPhone)
with open('export.json') as f:
    data = json.load(f)

mac_result = []
iphone_result = []

for record in data:
    platform = record['platform']
    device_id = record['device_id']
    email = record['user']['email'] if 'user' in record and isinstance(record['user'], dict) else ''
    # exclude development/testing devices via email i.e. development@acme.com
    if email != 'development@acme.com':
        if platform == 'Mac':
            mac_result.append({'platform': platform, 'device_id': device_id, 'email': email})
        elif platform == 'iPhone':
            iphone_result.append({'platform': platform, 'device_id': device_id, 'email': email})

# create platform:Mac json file
with open('MacDevices.json', 'w') as f:
    json.dump(mac_result, f, indent=4)

# create platform:iPhone json file
with open('iPhoneDevices.json', 'w') as f:
    json.dump(iphone_result, f, indent=4)


# remove original json dump from ListDevices API request    
os.remove("export.json")

print("Data gathered. See iPhoneDevices.json and MacDevices.json")