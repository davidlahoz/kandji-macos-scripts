# Created by David L. (https://github.com/davidlahoz)
import json


#Warning text
print('\033[1;31mImportant! Heavy API request. Might take some time.\033[0m')
print('\033[1;33m You will only get MacOS App List running this!\033[0m')
# Take user input for the app name
app_name = input("Enter the MacOS app name: ")

def find_email(data):
    emails = []
    for item in data:
        if isinstance(item, dict):
            if 'name' in item:
                if app_name in item['name']:
                    emails.append(item['email'])
            emails.extend(find_email(item.values()))
        elif isinstance(item, list):
            for elem in item:
                emails.extend(find_email(elem))
    return emails

with open('MacAppList.json', 'r') as f:
    data = json.load(f)

emails = find_email(data)

output = {'emails': emails}

# Construct the output file name
output_file_name = f"{app_name}_MacAppList.json"

with open(output_file_name, 'w') as f:
    json.dump(output, f)