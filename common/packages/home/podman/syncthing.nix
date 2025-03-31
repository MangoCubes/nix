{
  config,
  hostname,
  lib,
  headless,
  ...
}:
{
  home.activation.syncthing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    FILE=${config.home.homeDirectory}/.podman/syncthing/config.xml
    if [ ! -f "$FILE" ]; then
      mkdir -p ${config.home.homeDirectory}/Sync
      mkdir -p ${config.home.homeDirectory}/.podman/syncthing
      cp ${if headless then ./syncthing/config.xml else ./syncthing/config-client.xml} $FILE
    fi
  '';
  services.podman.containers.syncthing = (
    (import ../../../../lib/podman.nix) {
      inherit hostname;
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
