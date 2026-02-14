{ config, ... }:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "proton-exit" ];
      network = [ "container:proton-exit" ];
      image = "tailscale/tailscale:stable";
      name = "tailscale";
      environment = {
        TS_HOSTNAME = "exit";
        TS_EXTRA_ARGS = "--login-server=https://newvpn.skew.ch --advertise-exit-node";
      };
      volumes = [
        "${config.home.homeDirectory}/.podman/redis:/data"
      ];

    })
  ];
}
