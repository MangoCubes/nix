{ lib, ... }:
{
  options.custom.microsoftTeams = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
}
