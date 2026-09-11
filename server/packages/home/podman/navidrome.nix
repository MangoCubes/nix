{
  config,
  ...
}:
{
  custom.podman.containers = [
    {
      dependsOn = [ "traefik" ];
      image = "deluan/navidrome:latest";
      name = "navidrome";
      environment = {
        ND_AUTOIMPORTPLAYLISTS = "false";
      };
      domain = [
        {
          routerName = "navidrome";
          url = "music.int";
          type = "local";
          port = 4533;
        }
      ];
      volumes = [
        "${config.home.homeDirectory}/.podman/navidrome:/data"
        "${config.home.homeDirectory}/Mounts/koofr/Media/Music:/music/koofr"
        "${config.home.homeDirectory}/Mounts/drive/Archive/Music:/music/drive"
      ];
    }
  ];
}
