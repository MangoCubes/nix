{ config, ... }:
{
  custom.podman.containers = {
    archive = {
      dependsOn = [ "archive-es" ];
      redis = true;
      image = "bbilly1/tubearchivist";
      domain = [
        {
          url = "yt.int";
          port = 8000;
        }
      ];
      environment = {
        "ES_URL" = "http://archive-es:9200";
        "REDIS_CON" = "redis://redis-archive:6379";
        "HOST_UID" = "1000";
        "HOST_GID" = "1000";
        "TA_HOST" = "https://yt.int";
        "TZ" = "America/New_York";
        "TA_USERNAME" = "admin";
      };
      environmentFile = [ config.sops.secrets.archive.path ];
      volumes = [ "/cache" ];
      mounts = [
        {
          inside = "/youtube";
          outside = "${config.custom.bookmarks.Mounts.path}/drive/Archive/Video";
        }
      ];
    };
    # UID: 1000
    archive-es = {
      image = "bbilly1/tubearchivist-es";
      environment = {
        "ES_JAVA_OPTS" = "-Xms1g -Xmx1g";
        "xpack.security.enabled" = "true";
        "discovery.type" = "single-node";
        "path.repo" = "/usr/share/elasticsearch/data/snapshot";
      };
      environmentFile = [ config.sops.secrets.archive.path ];
      mounts = [
        {
          inside = "/usr/share/elasticsearch/data";
          outside = "archive-es";
        }
      ];
    };
  };
}
