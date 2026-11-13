{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.custom.device.type == "laptop") {
    services.logind.settings.Login.HandleLidSwitch = lib.mkDefault "ignore";
    environment.systemPackages = [ pkgs.brightnessctl ];
  };
}
