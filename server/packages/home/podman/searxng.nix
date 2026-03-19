{ config, ... }:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "searxng/searxng:latest";
      name = "search";
      dns = "1.1.1.1";
      domain = [
        {
          routerName = "searxng";
          type = 1;
          url = "genit.al";
          port = 8080;
        }
      ];
      volumes = [
        "${config.home.homeDirectory}/.podman/searxng:/etc/searxng"
      ];
    })
  ];
}
