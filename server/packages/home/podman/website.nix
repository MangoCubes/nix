{
  config,
  lib,
  pkgs,
  ...
}:
let
  routing = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (key: value: ''
      location /${key} {
          root /usr/share/nginx/html;
          ${lib.optionalString (value.type != null) "default_type ${value.type};"}
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList (key: value: ''add_header ${key} "${value}";'') value.headers
          )}
          ${lib.optionalString (value.index != null) "index ${value.index};"}
      }
    '') config.custom.web
  );
  conf = pkgs.writeText "default.conf" ''
    server {
        listen       80;
        server_name  localhost;

    	${routing}
    }
  '';

  volumes =
    (lib.mapAttrsToList (
      key: value: "${value.content}:/usr/share/nginx/html/${key}:ro"
    ) config.custom.web)
    ++ [
      "${conf}:/etc/nginx/conf.d/default.conf:ro"
    ];
in
{
  custom.web."" = {
    content = "${config.home.homeDirectory}/Sync/Website/public_html";
    index = "index.html";
  };
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
