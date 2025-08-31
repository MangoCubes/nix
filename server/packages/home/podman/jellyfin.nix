{
  config,
  ...
}:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "lscr.io/linuxserver/jellyfin:latest";
      name = "jellyfin";
      volumes = [
        "${config.home.homeDirectory}/Mount/media/Library/Anime:/media"
        "${config.home.homeDirectory}/.podman/jellyfin:/config"
      ];
      domain = [
        {
          routerName = "jellyfin";
          type = 2;
          url = "media.local";
          port = 8096;
        }
      ];
    })
  ];
}
