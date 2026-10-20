{ config, ... }:
{
  custom.podman.containers.search = {
    image = "searxng/searxng:latest";
    disk.persistOnly = [ "searxng" ];
    domain = [
      {
        url = "genit.al";
        port = 8080;
      }
    ];
    volumes = [
      "${config.home.homeDirectory}/.podman/searxng:/etc/searxng"
    ];
  };
}
