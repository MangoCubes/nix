{ config, inputs, ... }:
{
  imports = [
    inputs.secrets.server-main.home.dustcal
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "ghcr.io/mangocubes/dustcal:master";
      name = "dustcal";
      environmentFile = [ "${config.home.homeDirectory}/.config/sops-nix/secrets/dustcal" ];
      domain = [
        {
          routerName = "dustcal";
          url = "dustcal.skew.ch";
          type = 1;
          port = 3000;
        }
      ];
    })
  ];
}
