{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.secrets.hm.cloud ];
  home.activation.cloud = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/.podman/cloud
    # mkdir -p ${config.home.homeDirectory}/.podman/cloud/config
    # cp ${config.home.homeDirectory}/.config/sops-nix/secrets/cloud ${config.home.homeDirectory}/.podman/cloud/config/config.php
    # mkdir -p ${config.home.homeDirectory}/.podman/cloud/php
    # mkdir -p ${config.home.homeDirectory}/.podman/cloud/crontabs
    # mkdir -p ${config.home.homeDirectory}/.podman/cloud/data
    # ${pkgs.rootlesskit}/bin/rootlesskit chown -R 1000:1000 ${config.home.homeDirectory}/.podman/cloud
  '';
  services.podman.containers.cloud = (
    (import ../../../../lib/podman.nix) {
      image = "linuxserver/nextcloud:latest";
      name = "cloud";
      domain = [
        {
          routerName = "cloud";
          type = 1;
          url = "cloud.skew.ch";
          port = 80;
        }
      ];
      volumes = [
        "${config.home.homeDirectory}/.podman/cloud/config:/config/www/nextcloud/config"
        "${config.home.homeDirectory}/.podman/cloud/php:/config/php"
        "${config.home.homeDirectory}/.podman/cloud/crontabs:/config/crontabs"
        "${config.home.homeDirectory}/.podman/cloud/data:/data"
        "cloud:/config/www/nextcloud/apps"
        # "${config.home.homeDirectory}/.podman/cloud/remoteip.conf:/etc/apache2/conf-enabled/remoteip.conf:ro"
      ];
      environment = {
        "PUID" = "1000";
        "PGID" = "1000";
        "NEXTCLOUD_TRUSTED_DOMAINS" = "cloud.skew.ch";
        #"REDIS_HOST" = "redis"
        #"REDIS_PORT" = "6379"
        #"REDIS_HOST_PASSWORD" = "asdfasdf"
        "traefik.http.middlewares.m-cloud.headers.customFrameOptionsValue" = "SAMEORIGIN";
        "traefik.http.middlewares.m-cloud.headers.framedeny" = "true";
        "traefik.http.middlewares.m-cloud.headers.sslredirect" = "true";
        "traefik.http.middlewares.m-cloud.headers.STSIncludeSubdomains" = "true";
        "traefik.http.middlewares.m-cloud.headers.STSPreload" = "true";
        "traefik.http.middlewares.m-cloud.headers.STSSeconds" = "315360000";
        "traefik.http.middlewares.m-cloud.headers.forceSTSHeader" = "true";
        "traefik.http.middlewares.m-cloud.headers.sslProxyHeaders.X-Forwarded-Proto" = "https";
        "traefik.http.middlewares.m-cloud-dav.replacepathregex.regex" = "^/.well-known/ca(l|rd)dav";
        "traefik.http.middlewares.m-cloud-dav.replacepathregex.replacement" = "/remote.php/dav/";
        "traefik.http.middlewares.m-cloud-webfinger.replacepathregex.regex" = "^/.well-known/webfinger";
        "traefik.http.middlewares.m-cloud-webfinger.replacepathregex.replacement" =
          "/index.php/.well-known/webfinger";
        "traefik.http.middlewares.m-cloud-nodeinfo.replacepathregex.regex" = "^/.well-known/nodeinfo";
        "traefik.http.middlewares.m-cloud-nodeinfo.replacepathregex.replacement" =
          "/index.php/.well-known/nodeinfo";
        "traefik.http.routers.cloud.middlewares" =
          "m-cloud@docker,m-cloud-dav@docker,m-cloud-webfinger@docker,m-cloud-nodeinfo@docker";
      };
    }
  );
}
