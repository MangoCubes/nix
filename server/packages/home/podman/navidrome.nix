{ config, ... }:
{
  custom.podman.containers.navidrome = {
    image = "deluan/navidrome:latest";
    environment = {
      ND_AUTOIMPORTPLAYLISTS = "false";
    };
    domain = [
      {
        url = "music.int";
        port = 4533;
      }
    ];
    mounts = [
      {
        inside = "/data";
        outside = "navidrome";
      }
      {
        inside = "/music/koofr";
        outside = "${config.custom.bookmarks.Mounts.path}/koofr/Media/Music";
      }
      {
        inside = "/music/drive";
        outside = "${config.custom.bookmarks.Mounts.path}/drive/Archive/Music";
      }
    ];
  };
}
