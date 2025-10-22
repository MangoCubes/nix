{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.image
    ../packages/restic.nix
    ../../common/packages/rclone-mega.nix
    ./traefik.nix
    ../packages/podman/mitmproxy-wg.nix
    ./home.nix
    ./networking.nix
    ../base/configuration.nix
  ];
}
