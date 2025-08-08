{
  config,
  lib,
  ...
}:
{
  home.activation.kavita = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/.podman/kavita
  '';
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "jvmilazz0/kavita:latest";
      name = "kavita";
      volumes = [
        "${config.home.homeDirectory}/.podman/kavita:/var/lib/kavita"
        "${config.home.homeDirectory}/Mount/media/Library/Manga:/manga"
      ];
      domain = [
        {
          routerName = "manga";
          type = 2;
          url = "manga.local";
          port = 5000;
        }
      ];
    })
  ];
}
