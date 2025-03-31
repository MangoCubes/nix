{ hostname, config, ... }:
{
  services.podman.containers.search = (
    (import ../../../../lib/podman.nix) {
      inherit hostname;
      image = "searxng/searxng:latest";
      name = "search";
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
    }
  );
}
