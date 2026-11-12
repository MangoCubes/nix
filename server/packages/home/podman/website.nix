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

  mounts =
    lib.mapAttrsToList (key: value: {
      inside = "/usr/share/nginx/html/${key}";
      outside = value.content;
      readOnly = true;
    }) config.custom.web
    ++ [
      {
        inside = "/etc/nginx/conf.d/default.conf";
        outside = "${conf}";
        readOnly = true;
      }
    ];
in
{
  custom.web."" = {
    content = "${config.custom.bookmarks.Sync.path}/Website/public_html";
    index = "index.html";
  };
  imports = [
    ./web/options.nix
  ];
  custom.podman.containers.website = {
    image = "nginx:stable-alpine";
    domain = [
      {
        url = "skew.ch";
        port = 80;
      }
    ];
    inherit mounts;
  };
}
