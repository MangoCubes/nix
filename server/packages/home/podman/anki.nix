{
  config,
  ...
}:
let dir = "${config.home.homeDirectory}/.podman/anki:/app/data"; in
{
  custom.backups.backblaze = [ dir ];
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "kuklinistvan/anki-sync-server:latest";
      name = "anki";
      domain = [
        {
          routerName = "anki";
          type = 2;
          url = "anki.int";
          port = 27701;
        }
      ];
      volumes = [ dir ];
    })
  ];
}
