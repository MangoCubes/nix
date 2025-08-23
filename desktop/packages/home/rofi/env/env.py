import os
import sys
import json
from typing import TypedDict, Dict, Optional
import subprocess

def ping(host: str) -> bool:
    """
    Returns True if host (str) responds to a ping request.
    Remember that a host may not respond to a ping (ICMP) request even if the host name is valid.
    """
    # Building the command. Ex: "ping -c 1 google.com"
    command = ['ping', '-c', '1', host]
    return subprocess.call(command) == 0

def ping_multiple_with_fallback() -> bool:
    """
    Pings multiple hosts to check if the internet is available.
    Returns True if any of the hosts respond to a ping request.
    """
    hosts = ['skew.ch', 'genit.al', '1.1.1.1', '8.8.8.8']
    for host in hosts:
        if ping(host):
            return True
    return False

class Env(TypedDict):
    command: str
    offline: Optional[str]

Envs = Dict[str, Env]

home = os.path.expanduser("~")

file = os.path.join(home, "Sync/LinuxConfig/data/projects/projects.json")

data: Envs

def run_cmd(cmd: str, msg: Optional[str]) -> None:
    if msg is None:
        subprocess.Popen(["kitty", "bash", "-c", cmd], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    else:
        subprocess.Popen(["kitty", "bash", "-c", "echo " + msg + "; " + cmd], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        

try:
    with open(file, 'r') as f:
        data = json.load(f)
except FileNotFoundError:
    print(f"The file {file} does not exist.")
    sys.exit(0)

if len(sys.argv) <= 1:
    for key in data.keys():
        print(f"{key}")
    sys.exit(0)
elif len(sys.argv) == 2:
    offline = data[sys.argv[1]]['offline']
    cmd = data[sys.argv[1]]['command']
    if offline is None:
        run_cmd(cmd, None)
    else:
        if ping_multiple_with_fallback():
            run_cmd(cmd, None)
        else:
            run_cmd(offline, "Running in offline mode.")
    sys.exit(0)
else:
    print(f"Invalid number of arguments.")
    sys.exit(2)
