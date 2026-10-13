{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}:
let
  cfg = config.custom.kdeconnect;
in
{
  options.custom.kdeconnect = {
    enable = lib.mkEnableOption "KDE Connect";
    trustedDevices = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.sshfs ];
    services.kdeconnect.enable = true;
    xdg.configFile = {
      "kdeconnect/config".text = ''
        [General]
        name=${osConfig.networking.hostName}
        keyAlgorithm=EC
        customDevices=phone.local,main.local,windows-work.local,windows-laptop2.local,laptop2.local
      '';
      "kdeconnect/trusted_devices".text = cfg.trustedDevices;
    };
  };
}
