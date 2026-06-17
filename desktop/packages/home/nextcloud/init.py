import os
import sys
import subprocess
from datetime import datetime
from pathlib import Path

HOME = Path.home()
NC_URL = "https://cloud.skew.ch"
EXCLUDE_FILE = HOME / "Sync/GeneralConfig/Nextcloud/sync-exclude.lst"
DIRS_FILE = HOME / "Sync/GeneralConfig/Nextcloud/dirs.lst"

def get_secret(attribute: str, value: str) -> str:
    try:
        result = subprocess.run(
            ["secret-tool", "lookup", attribute, value],
            capture_output=True, text=True, check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error retrieving secret for {value}: {e}", file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print(f"Error: secret-tool not found!", file=sys.stderr)
        sys.exit(1)

def load_sync_dirs() -> dict:
    dirs = {}
    if not DIRS_FILE.is_file():
        print(f"Error: Directory list file not found at {DIRS_FILE}!", file=sys.stderr)
        sys.exit(1)

    with DIRS_FILE.open("r") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            local_path = str(HOME / "Nextcloud" / line)
            remote_path = f"/{line}"
            dirs[local_path] = remote_path
    return dirs

def sync_directory(local_path: str, remote_path: str, nc_user: str, nc_password: str):
    current_time = datetime.now().strftime('%H:%M:%S')
    print(f"[{current_time}] Synchronising: {local_path} <-> {remote_path}", flush=True)

    os.makedirs(local_path, exist_ok=True)

    cmd = ["nextcloudcmd", "-u", nc_user, "-p", nc_password, "-h", "--exclude", str(EXCLUDE_FILE), "--path", remote_path, local_path, NC_URL]
    subprocess.run(cmd)

nc_user = get_secret("Use", "Nextcloud_Username")
nc_password = get_secret("Use", "Nextcloud_Password")
sync_dirs = load_sync_dirs()

print("Starting initial sync...", flush=True)
for local_dir, remote_dir in sync_dirs.items():
    sync_directory(local_dir, remote_dir, nc_user, nc_password)
print("Initial synchronization completed.", flush=True)
