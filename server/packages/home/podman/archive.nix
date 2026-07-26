{ config, ... }:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [
        "traefik"
        "archive-es"
        "archive-redis"
      ];
      image = "bbilly1/tubearchivist";
      name = "archive";
      domain = [
        {
          routerName = "archive";
          url = "yt.int";
          type = 1;
          port = 8000;
        }
      ];
      environment = {
        "ES_URL" = "http://archive-es:9200";
        "REDIS_CON" = "redis://archive-redis:6379";
        "HOST_UID" = "1000";
        "HOST_GID" = "1000";
        "TA_HOST" = "https://yt.int";
        "ELASTIC_PASSWORD" = "7WR3cPbAbRkgvfUoUSaQRechfQjLZyJ2";
        "TZ" = "America/New_York";
        "TA_USERNAME" = "admin";
        "TA_PASSWORD" = "XTQVSNXTSfcCEQUFwYScxZUgZDd3FYh3";
      };
      volumes = [
        "cache:/cache"
        "${config.home.homeDirectory}/Mounts/Drive/Archive/Video:/youtube"
      ];
    })
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "archive-es" ];
      image = "redis";
      name = "archive-redis";
    })
    # UID: 1000
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ ];
      image = "bbilly1/tubearchivist-es";
      name = "archive-es";
      environment = {
        "ELASTIC_PASSWORD" = "7WR3cPbAbRkgvfUoUSaQRechfQjLZyJ2";
        "ES_JAVA_OPTS" = "-Xms1g -Xmx1g";
        "xpack.security.enabled" = "true";
        "discovery.type" = "single-node";
        "path.repo" = "/usr/share/elasticsearch/data/snapshot";
      };
      volumes = [
        "${config.home.homeDirectory}/.podman/archive-es:/usr/share/elasticsearch/data"
      ];
    })
  ];
}
