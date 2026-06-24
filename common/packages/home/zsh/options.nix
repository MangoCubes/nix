{ lib, ... }:
{
  options.custom.shell = {
    program = lib.mkOption {
      type = lib.types.str;
    };
    aliases = lib.mkOption {
      type = (lib.types.attrsOf lib.types.str);
    };
  };
}
