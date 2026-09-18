{ config, ... }:
{
  custom.podman.containers.navidrome = {
    dependsOn = [ "traefik" ];
    image = "deluan/navidrome:latest";
    environment = {
      ND_AUTOIMPORTPLAYLISTS = "false";
    };
    domain = [
      {
        routerName = "navidrome";
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
