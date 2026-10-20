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
      "${config.home.homeDirectory}/Mounts/koofr/Media/Music:/music/koofr"
      "${config.home.homeDirectory}/Mounts/drive/Archive/Music:/music/drive"
    ];
  };
}
