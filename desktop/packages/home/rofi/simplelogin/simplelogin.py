import os
import random
import json
import sys
from subprocess import Popen, PIPE
import http.client

use_random = False

process = Popen(["rofi-input", "Email"], stdout=PIPE)
(output, err) = process.communicate()
exit_code = process.wait()

if(exit_code):
    sys.exit(exit_code)

name = str(output.decode('utf-8')).strip()

if(len(name) == 0):
    use_random = True

process = Popen(["rofi-input", "Notes"], stdout=PIPE)
(output, err) = process.communicate()
exit_code = process.wait()

if(exit_code):
    sys.exit(exit_code)

notes = str(output.decode('utf-8')).strip()

home = os.path.expanduser("~")

file = os.path.join(home, ".config/sops-nix/secrets/simplelogin")

token: str

with open(file, 'r') as file:
    token = file.readline().strip()

conn = http.client.HTTPSConnection("app.simplelogin.io")
headers = {
    "Content-Type": "application/json",
    "Authentication": token
}
conn.request("GET", "/api/v2/mailboxes", headers=headers)

data = conn.getresponse().read()
mailbox = [item for item in json.loads(data)["mailboxes"] if item["default"]][0] 

conn.request("GET", "/api/v5/alias/options", headers=headers)

response = conn.getresponse()
data = response.read()

premium_items = [item for item in json.loads(data)["suffixes"] if item['is_premium']]
suffix = random.choice(premium_items)["signed_suffix"]

info = {
    "alias_prefix": name,
    "note": notes,
    "signed_suffix": suffix,
    "mailbox_ids": [mailbox["id"]]
}

conn.request("POST", "/api/v3/alias/custom/new", headers=headers, body=json.dumps(info))

response = conn.getresponse()
data = response.read()

if 200 <= response.status < 300:
    alias = json.loads(data)["email"]
    process = Popen(['wl-copy'], stdin=PIPE)
    process.communicate(input=alias.encode('utf-8'))
else:
    process = Popen(['wl-copy'], stdin=PIPE)
    process.communicate(input=("ERROR: " + str(response.status)).encode('utf-8'))

conn.close()

sys.exit(0)


