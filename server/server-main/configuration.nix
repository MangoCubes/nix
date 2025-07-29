{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.image
    ../../common/packages/rclone-mega.nix
    ../packages/traefik.nix
    ../packages/podman/mitmproxy-wg.nix
    ./home.nix
    ./networking.nix
    ../base/configuration.nix
  ];
}
