{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.image
    ../packages/restic.nix
    inputs.secrets.server-main.restic
    ../../common/packages/rclone-mega.nix
    ../packages/podman/proton-exit.nix
    ./traefik.nix
    ../packages/podman/mitmproxy-wg.nix
    ./home.nix
    ./networking.nix
    ../base/configuration.nix
  ];
}
