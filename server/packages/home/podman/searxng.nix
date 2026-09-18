{ config, ... }:
{
  custom.podman.containers.search = {
    dependsOn = [ "traefik" ];
    image = "searxng/searxng:latest";
    domain = [
      {
        routerName = "searxng";
        url = "genit.al";
        port = 8080;
      }
    ];
    volumes = [
      "${config.home.homeDirectory}/.podman/searxng:/etc/searxng"
    ];
  };
}
