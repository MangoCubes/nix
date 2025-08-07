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
    find . -type f -name '*sync-conflict*' -exec rm {} +
  '';
  st-reset-database = pkgs.writeShellScriptBin "st-reset-database" ''
    systemctl --user stop podman-syncthing || { echo "Failed to stop Syncthing."; exit 1; }
    podman run --rm -e GUID=0 -e PUID=0 --user 0 --volume ${config.home.homeDirectory}/Sync:/var/syncthing/data \
      --volume ${config.home.homeDirectory}/.podman/syncthing:/var/syncthing/config syncthing/syncthing --reset-database;
    systemctl --user restart podman-syncthing
  '';
  st-reset-deltas = pkgs.writeShellScriptBin "st-reset-deltas" ''
    systemctl --user stop podman-syncthing || { echo "Failed to stop Syncthing."; exit 1; }
    podman run --rm -e GUID=0 -e PUID=0 --user 0 --volume ${config.home.homeDirectory}/Sync:/var/syncthing/data \
      --volume ${config.home.homeDirectory}/.podman/syncthing:/var/syncthing/config syncthing/syncthing --reset-deltas;
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
  ];
  home = {
    packages = [
      st-clear
      st-reset-deltas
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
  services.podman.containers.syncthing = (
    (import ../../../../lib/podman.nix) {
      needRoot = true;
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
      exec = "--reset-deltas";
      extraPodmanArgs = [ "--hostname=${hostname}" ];
      ports = [
        "22000:22000/tcp"
        "22000:22000/udp"
        "8384:8384"
        "21027:21027/udp"
      ];
    }
  );
}

# yq --input-format json --output-format xml --xml-attribute-prefix @ ./test.json
