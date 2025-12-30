{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.image
    inputs.secrets.hw.server-media
    inputs.secrets.config.server-media
    ../packages/xfce.nix
    ../base/configuration.nix
    ../../common/packages/rclone-mega.nix
  ];
}
