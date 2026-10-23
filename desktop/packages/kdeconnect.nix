{
  pkgs,
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.custom.kdeconnect;
  genSettings = lib.generators.toINI {
    mkKeyValue = lib.generators.mkKeyValueDefault { mkValueString = builtins.toJSON; } "=";
  };
  cmds = genSettings {
    General.commands = "@ByteArray(${
      builtins.toJSON (lib.mapAttrs (name: command: { inherit name command; }) cfg.commands)
    })";
  };
in
{
  options.custom.kdeconnect = {
    enable = lib.mkEnableOption "KDE Connect";
    trustedDevices = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption { type = lib.types.str; };
            type = lib.mkOption {
              type = lib.types.enum [
                "desktop"
                "laptop"
                "phone"
                "tablet"
                "tv"
              ];
            };
            certificate = lib.mkOption { type = lib.types.str; };
            protocolVersion = lib.mkOption {
              type = lib.types.int;
              default = 8;
            };
          };
        }
      );
      default = { };
    };
    commands = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users."${username}" = {
      home.packages = [ pkgs.sshfs ];
      services.kdeconnect.enable = true;
      xdg.configFile = {
        "kdeconnect/config".text = genSettings {
          General = {
            name = config.networking.hostName;
            keyAlgorithm = "EC";
          };
        };
        "kdeconnect/trusted_devices".text = genSettings cfg.trustedDevices;
      }
      // lib.concatMapAttrs (
        id: device:
        lib.optionalAttrs
          (lib.elem device.type [
            "phone"
            "tablet"
          ])
          {
            "kdeconnect/${id}/kdeconnect_runcommand/config".text = cmds;
          }
      ) cfg.trustedDevices;
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
