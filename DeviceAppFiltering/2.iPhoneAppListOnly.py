import requests
import json

api_key = "CHANGEME"

#CHANGE SUBDOMAIN AND REGION IF NEEDED.
# US - https://SubDomain.api.kandji.io
# EU - https://SubDomain.api.eu.kandji.io
url_template = "https://subdomain.api.eu.kandji.io/api/v1/devices/{}/apps" #change subdomain 

# Listing iPhoneApps
with open('iPhoneDevices.json') as f:
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

with open('iPhoneAppList.json', 'w') as f:
  
    json.dump(apps, f, indent=4)
    
    print("Data gathered. See iPhoneAppList.json for iPhone App List by user.")