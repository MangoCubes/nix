{ config, ... }:
{
  custom.podman.containers = [
    {
      dependsOn = [ "traefik" ];
      image = "searxng/searxng:latest";
      name = "search";
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
    }
  ];
}
