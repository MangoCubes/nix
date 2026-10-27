{
  inputs,
  config,
  username,
  lib,
  ...
}:
{
  programs.fuse = {
    userAllowOther = true;
    enable = true;
  };
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.src_valid_mark" = 1;
  };
  imports = [
    inputs.secrets.hw.image
    ../packages/restic.nix
    inputs.secrets.server-main.restic
    inputs.secrets.server-main.config
    ../packages/podman/mitmproxy-wg.nix
    ./home.nix
  ];
  networking.firewall.interfaces.${config.services.netbird.clients.personal.interface}.allowedTCPPorts =
    [
      (lib.toInt
        config.home-manager.users."${
          username
        }".custom.podman.containers.gitea.environment.GITEA__server__SSH_PORT
      )
    ];
}
