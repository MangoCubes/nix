{
  config,
  ...
}:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "deluan/navidrome:latest";
      name = "navidrome";
      domain = [
        {
          routerName = "navidrome";
          url = "music.int";
          type = 2;
          port = 4533;
        }
      ];
      volumes = [
        "${config.home.homeDirectory}/.podman/navidrome:/data"
        "${config.home.homeDirectory}/Mounts/koofr/Media/Music:/music/koofr"
        "${config.home.homeDirectory}/Mounts/drive/Archive/Music:/music/drive"
      ];
    })
  ];
}
