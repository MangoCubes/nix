{
  config,
  inputs,
  ...
}:
{
  # cp ${config.home.homeDirectory}/.config/sops-nix/secrets/cloud ${config.home.homeDirectory}/.podman/cloud/config/config.php
  # ${pkgs.rootlesskit}/bin/rootlesskit chown -R 1000:1000 ${config.home.homeDirectory}/.podman/cloud
  imports = [
    inputs.secrets.server.packages.home.podman.cloud
  ];
  custom.podman.containers.cloud = {
    dependsOn = [ "mariadb" ];
    image = "linuxserver/nextcloud:latest";
    backup = [ "cloud/data/user/files" ];
    domain = [
      {
        url = "cloud.skew.ch";
        port = 80;
        extraRouterConfig.middlewares = "m-cloud@docker,m-cloud-dav@docker,m-cloud-webfinger@docker,m-cloud-nodeinfo@docker";
      }
    ];
    mounts = [
      {
        inside = "/config/www/nextcloud/config";
        outside = "cloud/config";
      }
      {
        inside = "/config/php";
        outside = "cloud/php";
      }
      {
        inside = "/config/crontabs";
        outside = "cloud/crontabs";
      }
      {
        inside = "/data";
        outside = "cloud/data";
      }
      # {
      #   inside = "/etc/apache2/conf-enabled/remoteip.conf";
      #   outside = "cloud/remoteip.conf";
      #   create = false;
      #   readOnly = true;
      # }
    ];
    volumes = [ "/config/www/nextcloud/apps" ];
    uid = 1000;
    environment = {
      "PUID" = "1000";
      "PGID" = "1000";
      "NEXTCLOUD_TRUSTED_DOMAINS" = "cloud.skew.ch";
      #"REDIS_HOST" = "redis"
      #"REDIS_PORT" = "6379"
      #"REDIS_HOST_PASSWORD" = "asdfasdf"
    };
    labels = {

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
    };
  };
}
