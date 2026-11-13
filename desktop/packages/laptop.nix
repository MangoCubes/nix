{ config, lib, ... }:
{
  config = lib.mkIf (config.custom.device.type == "laptop") {
    services.logind.settings.Login.HandleLidSwitch = lib.mkDefault "ignore";
  };
}
