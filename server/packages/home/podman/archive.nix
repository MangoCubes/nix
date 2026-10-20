{ config, ... }:
{
  custom.podman.containers = {
    archive = {
      dependsOn = [
        "archive-es"
        "archive-redis"
      ];
      image = "bbilly1/tubearchivist";
      domain = [
        {
          url = "yt.int";
          port = 8000;
        }
      ];
      environment = {
        "ES_URL" = "http://archive-es:9200";
        "REDIS_CON" = "redis://archive-redis:6379";
        "HOST_UID" = "1000";
        "HOST_GID" = "1000";
        "TA_HOST" = "https://yt.int";
        "TZ" = "America/New_York";
        "TA_USERNAME" = "admin";
      };
      environmentFile = [ config.sops.secrets.archive.path ];
      volumes = [
        "cache:/cache"
        "${config.home.homeDirectory}/Mounts/Drive/Archive/Video:/youtube"
      ];
    };
    archive-redis = {
      image = "redis";
    };
    # UID: 1000
    archive-es = {
      image = "bbilly1/tubearchivist-es";
      disk.persistOnly = [ "archive-es" ];
      environment = {
        "ES_JAVA_OPTS" = "-Xms1g -Xmx1g";
        "xpack.security.enabled" = "true";
        "discovery.type" = "single-node";
        "path.repo" = "/usr/share/elasticsearch/data/snapshot";
      };
      environmentFile = [ config.sops.secrets.archive.path ];
      volumes = [
        "${config.home.homeDirectory}/.podman/archive-es:/usr/share/elasticsearch/data"
      ];
    };
  };
}
