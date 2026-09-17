{ inputs, ... }:
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
    ../packages/podman/mitmproxy-wg.nix
    ../../common/packages/k3s.nix
    ./home.nix
  ];
}
