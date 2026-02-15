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
        TS_AUTH_ONCE = "true";
        TS_EXTRA_ARGS = "--login-server=https://newvpn.skew.ch --advertise-exit-node";
        TS_STATE_DIR = "/var/lib/tailscale";
      };
      volumes = [
        "${config.home.homeDirectory}/.podman/tailscale:/var/lib/tailscale"
      ];
    })
  ];
}
