{ config, ... }:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
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
    })
  ];
}
