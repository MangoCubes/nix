{ inputs, ... }:
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.src_valid_mark" = 1;
  };
  imports = [
    inputs.secrets.hw.image
    ../packages/restic.nix
    inputs.secrets.server-main.restic
    ../../common/packages/rclone-mega.nix
    ./traefik.nix
    ../packages/podman/mitmproxy-wg.nix
    ./home.nix
    ./networking.nix
    ../base/configuration.nix
  ];
}
