{ config, ... }:
{
  services.podman.containers.website = (
    (import ../../../../lib/podman.nix) {
      image = "nginx:stable-alpine";
      name = "website";
      domain = [
        {
          routerName = "website";
          url = "skew.ch";
          type = 1;
          port = 80;
        }
      ];
      volumes = [
        "${config.home.homeDirectory}/Sync/Website/public_html:/usr/share/nginx/html:ro"
      ];
    }
  );
}
