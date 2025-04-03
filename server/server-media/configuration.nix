{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.image
    inputs.secrets.hw.server-media
    inputs.secrets.config.server-media
    ../../common/packages/rclone.nix
    ../packages/xfce.nix
  ];
}
