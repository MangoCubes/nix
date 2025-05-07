{
  hostname,
  config,
  lib,
  ...
}:
{
  home.activation.jellyfin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/.podman/jellyfin
  '';
  services.podman.containers.jellyfin = (
    (import ../../../../lib/podman.nix) {
      inherit hostname;
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
    }
  );
}
