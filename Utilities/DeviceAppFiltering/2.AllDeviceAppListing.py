# Created by David L. (https://github.com/davidlahoz)
import requests
import json

# Load the JSON configuration file
with open('config.json', 'r') as config_file:
    config_data = json.load(config_file)

# Access the variables
subdomain = config_data['subdomain']
api_key = config_data['api_key']

#Warning text
print('\033[1;31mWarning! Heavy API request. Please wait!\033[0m')
print('\033[1;33mGetting Apps from all iPhones and Macbooks on Kandji. You will get two json output files!\033[0m')

#Script variables
url_template = F"https://{subdomain}.api.eu.kandji.io/api/v1/devices/{}/apps"

# Function to gather app lists
def gather_app_list(device_file, output_file):
    with open(device_file) as f:
        devices = json.load(f)

    apps = []

    for device in devices:
        device_id = device['device_id']
        email = device['email'] if 'email' in device else ''
        url = url_template.format(device_id)
        headers = {'Authorization': f'Bearer {api_key}'}
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        apps_data = response.json()
        applist = []
        for app in apps_data['apps']:
            applist.append(app['app_name'])
        applist.sort()
        apps.append({'device_id': device_id, 'email': email, 'name': applist})

    with open(output_file, 'w') as f:
        json.dump(apps, f, indent=4)

    print(f"Data gathered. See {output_file} for App List by user.")


# Gather iPhone app list
gather_app_list('iPhoneDevices.json', 'iPhoneAppList.json')

# Gather Mac app list
gather_app_list('MacDevices.json', 'MacAppList.json')
