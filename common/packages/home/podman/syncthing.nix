{
  config,
  hostname,
  lib,
  device,
  inputs,
  pkgs,
  ...
}:
let
  st-clear = pkgs.writeShellScriptBin "st-clear" ''
    search_dir="."
    files=$(find "$search_dir" -type f -name "*sync-conflict*")

    if [[ -z "$files" ]]; then
        echo "No files found with 'sync-conflict' in their names."
        exit 0
    fi

    while IFS= read -r file; do
        original="''${file%%.sync-conflict-*}"
        if [[ -f "$original" ]]; then
            echo "Found: $file"
            hash1=$(sha256sum "$file" | awk '{ print $1 }')
            hash2=$(sha256sum "$original" | awk '{ print $1 }')
            if [[ "$hash1" == "$hash2" ]]; then
                echo "Conflict file $file is identical, deleting..."
                rm $file
            else
                echo "$original is different from conflicting copy."
                if [[ "$1" == "-f" ]]; then
                    rm $file
                fi
            fi
        else
            echo "Warning: Found conflict file without original file ($file)"
        fi
    done <<< "$files"
    exit 0
  '';
  st-reset-database = pkgs.writeShellScriptBin "st-reset-database" ''
    podman exec -it syncthing syncthing debug reset-database;
    systemctl --user restart podman-syncthing
  '';
in
{
  imports = [
    (
      if device == "server" then
        inputs.secrets.hm.syncthing-server
      else
        inputs.secrets.hm.syncthing-client
    )
    ((import ../../../../lib/podman.nix) {
      needRoot = true;
      dependsOn = [ "traefik" ];
      image = "syncthing/syncthing";
      name = "syncthing";
      volumes = [
        "${config.home.homeDirectory}/Sync:/var/syncthing/data"
        "${config.home.homeDirectory}/.podman/syncthing:/var/syncthing/config"
      ];
      environment = {
        PUID = "0";
        GUID = "0";
      };
      domain = [
        {
          routerName = "syncthing";
          type = 3;
          url = "sync.${hostname}.local";
          port = 8384;
        }
      ];
      # exec = "--reset-deltas";
      extraPodmanArgs = [ "--hostname=${hostname}" ];
      ports = [
        "22000:22000/tcp"
        "22000:22000/udp"
        "8384:8384"
        "21027:21027/udp"
      ];
    })
  ];
  home = {
    packages = [
      st-clear
      st-reset-database
    ];
    activation.syncthing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      FILE=${config.home.homeDirectory}/.podman/syncthing/config.xml
      if [ ! -f "$FILE" ]; then
        mkdir -p ${config.home.homeDirectory}/Sync
        mkdir -p ${config.home.homeDirectory}/.podman/syncthing
        cp ${config.home.homeDirectory}/.config/sops-nix/secrets/syncthing $FILE
      fi
    '';
  };
}

# yq --input-format json --output-format xml --xml-attribute-prefix @ ./test.json
