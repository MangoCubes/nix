{
  config,
  ...
}:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "lscr.io/linuxserver/plex:latest";
      name = "plex";
      volumes = [
        "${config.home.homeDirectory}/Mount/media/Library/Anime:/media/Anime"
        "${config.home.homeDirectory}/Mounts/media/Library/Music:/media/Music"
        "${config.home.homeDirectory}/.podman/plex:/config"
      ];
      domain = [
        {
          routerName = "plex";
          type = 2;
          url = "media.local";
          port = 32400;
        }
      ];
      environment = {
        "PUID" = "1000";
        "PGID" = "1000";
        "TZ" = "Etc/UTC";
        "VERSION" = "docker";
      };
      environmentFile = [ ''${config.home.homeDirectory}/.config/sops-nix/secrets/plex'' ];
    })
  ];
}
