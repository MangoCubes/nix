{ config, ... }:
{
  custom.podman.containers.navidrome = {
    image = "deluan/navidrome:latest";
    disk.persistOnly = [ "navidrome" ];
    environment = {
      ND_AUTOIMPORTPLAYLISTS = "false";
    };
    domain = [
      {
        url = "music.int";
        port = 4533;
      }
    ];
    volumes = [
      "${config.home.homeDirectory}/.podman/navidrome:/data"
      "${config.custom.bookmarks.Mounts.path}/koofr/Media/Music:/music/koofr"
      "${config.custom.bookmarks.Mounts.path}/drive/Archive/Music:/music/drive"
    ];
  };
}
