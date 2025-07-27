import os
import sys
import json
from typing import TypedDict, Dict
import subprocess

class Env(TypedDict):
    command: str
    path: str

Envs = Dict[str, Env]

home = os.path.expanduser("~")

file = os.path.join(home, "Sync/LinuxConfig/data/projects/projects.json")

data: Envs

try:
    with open(file, 'r') as f:
        data = json.load(f)
except FileNotFoundError:
    print(f"The file {file} does not exist.")
    sys.exit(0)

if len(sys.argv) <= 1:
    for key in data.keys():
        if os.path.exists(data[key]['path']):
            print(f"{key}")
    sys.exit(0)
elif len(sys.argv) == 2:
    subprocess.Popen(["kitty", "bash", "-c", data[sys.argv[1]]['command']], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    sys.exit(0)
else:
    print(f"Invalid number of arguments.")
    sys.exit(2)
