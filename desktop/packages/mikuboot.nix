{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.mikuboot.nixosModules.default
  ];
  boot.plymouth = lib.mkForce {
    enable = true;
    themePackages = [ pkgs.mikuboot ];
    theme = "mikuboot";
  };
}
