{
  pkgs,
  config,
  inputs,
  ...
}:
let
  syncDirs =
    let
      f = dir: ''["/home/main/Nextcloud/${dir}"]="/${dir}"'';
      syncDirs = [
        "Temp"
        "Documents/Important"
        "Documents/School/6-1"
        "Documents/School/Research/Current"
        "Documents/School/Research/Templates"
        "Documents/School/TA"
        "Documents/School/Work/2026"
        "Documents/SelfStudy/Japanese"
        "Projects/ampterm"
        "Projects/dragevac"
        "Projects/School"
      ];
    in
    (builtins.concatStringsSep "\n" (builtins.map f syncDirs));
  syncScript = pkgs.writeShellScriptBin "sync-script" ''
    NC_USER=$(${pkgs.libsecret}/bin/secret-tool lookup Use Nextcloud_Username)
    NC_PASSWORD=$(${pkgs.libsecret}/bin/secret-tool lookup Use Nextcloud_Password)
    NC_URL="https://cloud.skew.ch"
    EXCLUDE_FILE="${config.home.homeDirectory}/Sync/GeneralConfig/Nextcloud/exclude.lst"

    declare -A SYNC_DIRS=(${syncDirs})

    exclude_patterns=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        exclude_patterns+=("$line")
    done < $EXCLUDE_FILE

    sync_directory() {
        local local_path="$1"
        local remote_path="''${SYNC_DIRS[$local_path]}"
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] Synchronising: $local_path -> $remote_path"
        ${pkgs.nextcloud-client}/bin/nextcloudcmd -u "$NC_USER" -p "$NC_PASSWORD" -h --exclude "$EXCLUDE_FILE" --path "$remote_path" "$local_path" "$NC_URL"
    }

    echo "Starting initial bulk synchronization..."
    for local_dir in "''${!SYNC_DIRS[@]}"; do
        sync_directory "$local_dir"
    done
    echo "Initial synchronization completed."

    LOCAL_PATHS=("''${!SYNC_DIRS[@]}")

    echo "Starting inotifywait to monitor for real-time changes..."

    ${pkgs.inotify-tools}/bin/inotifywait -m -r -e close_write,moved_to,moved_from,delete "''${LOCAL_PATHS[@]}" --format '%w%f' | \
    while read -r changed_file; do

        excluded=0
        filename=$(basename "$changed_file")

        for pattern in "''${exclude_patterns[@]}"; do
            if [[ "$filename" == $pattern || "$changed_file" == $pattern ]]; then
                excluded=1
                break
            fi
        done
        
        if [[ $excluded -eq 1 ]]; then
            continue
        fi

        for base_dir in "''${!SYNC_DIRS[@]}"; do
            if [[ "$changed_file" == "$base_dir"* ]]; then
                echo "[$(date +'%Y-%m-%d %H:%M:%S')] Change detected: $changed_file"
                sync_directory "$base_dir"
                break
            fi
        done
    done
  '';
in
{
  home.packages = [
    syncScript
  ];
  imports = [ inputs.secrets.hm.nextcloud ];
  systemd.user = {
    services = {
      rclone-cloud = {
        Unit = {
          Description = "Mount Nextcloud drive automatically";
        };
        Service = {
          Type = "notify";
          ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/Cloud";
          ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/rclone-cloud --vfs-cache-mode full mount \"cloud:\" %h/Mounts/Cloud";
          Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
          ExecStop = "/bin/fusermount -u %h/Mounts/Cloud";
        };
      };
      nextcloud-autosync = {
        Unit = {
          Description = "Auto sync Nextcloud";
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${syncScript}/bin/sync-script";
          Restart = "always";
          RestartSec = "10";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
    startServices = true;
  };
}
