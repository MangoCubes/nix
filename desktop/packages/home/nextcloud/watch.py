import os
import sys
import subprocess
import fnmatch
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

def load_exclude_patterns() -> list[str]:
    patterns = [".sync_*.db", ".sync_*.db-wal", ".sync_*.db-shm"]
    with EXCLUDE_FILE.open("r") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            patterns.append(line)
    return patterns

def sync_directory(local_path: str, remote_path: str, nc_user: str, nc_password: str):
    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(f"[{current_time}] Synchronising triggered for: {local_path}", flush=True)

    os.makedirs(local_path, exist_ok=True)
    cmd = ["nextcloudcmd", "-u", nc_user, "-p", nc_password, "-h", "--exclude", str(EXCLUDE_FILE), "--path", remote_path, local_path, NC_URL]
    subprocess.run(cmd)

def is_excluded(filepath: str, exclude_patterns: list) -> bool:
    path_parts = Path(filepath).parts

    for pattern in exclude_patterns:
        if '*' in pattern:
            if fnmatch.fnmatch(filepath, pattern) or any(fnmatch.fnmatch(part, pattern) for part in path_parts):
                return True
        else:
            if pattern in filepath:
                return True

    return False

nc_user = get_secret("Use", "Nextcloud_Username")
nc_password = get_secret("Use", "Nextcloud_Password")
sync_dirs = load_sync_dirs()
exclude_patterns = load_exclude_patterns()

local_paths = list(sync_dirs.keys())
print("Starting inotifywait to monitor for real-time changes...", flush=True)

inotify_cmd = ["inotifywait", "-m", "-r", "-e", "close_write,moved_to,moved_from,delete", "--format", "%w%f"] + local_paths

with subprocess.Popen(inotify_cmd, stdout=subprocess.PIPE, text=True, bufsize=1) as proc:
    if proc.stdout is None:
        print("Error: Could not attach to inotifywait stdout.", file=sys.stderr)
        sys.exit(1)

    for changed_file in proc.stdout:
        changed_file = changed_file.strip()
        if not changed_file:
            continue

        if is_excluded(changed_file, exclude_patterns):
            continue

        for base_dir, remote_dir in sync_dirs.items():
            if changed_file.startswith(base_dir):
                current_time = datetime.now().strftime('%H:%M:%S')
                print(f"[{current_time}] Change detected: {changed_file}", flush=True)
                sync_directory(base_dir, remote_dir, nc_user, nc_password)
                break
