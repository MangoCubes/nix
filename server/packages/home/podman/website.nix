{ config, lib, ... }:
let
  volumes = lib.mapAttrsToList (
    key: value: "${value}:/usr/share/nginx/html/${key}:ro"
  ) config.custom.web.content;
in
{
  custom.web.content."" = "${config.home.homeDirectory}/Sync/Website/public_html";
  imports = [
    ./web/options.nix
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
      inherit volumes;
    })
  ];
}
