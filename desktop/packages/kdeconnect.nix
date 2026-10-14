{
  pkgs,
  config,
  lib,
  username,
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
    home-manager.users."${username}" = {
      home.packages = [ pkgs.sshfs ];
      services.kdeconnect.enable = true;
      xdg.configFile = {
        "kdeconnect/config".text = ''
          [General]
          name=${config.networking.hostName}
          keyAlgorithm=EC
        '';
        "kdeconnect/trusted_devices".text = cfg.trustedDevices;
      };
    };

    networking.firewall = {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
