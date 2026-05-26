{ inputs, ... }:
{
  programs.fuse.userAllowOther = true;
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.src_valid_mark" = 1;
  };
  imports = [
    inputs.secrets.hw.image
    ../packages/restic.nix
    inputs.secrets.server-main.restic
    ./traefik.nix
    ../packages/podman/mitmproxy-wg.nix
    ../packages/podman/plex.nix
    ./home.nix
    ./networking.nix
  ];
}
