{ lib, ... }:
{
  options.custom = lib.mkOption {
    type = lib.types.submodule {
      options.windows = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      options.keys = lib.mkOption {
        type = lib.types.attrsOf (lib.types.str);
      };
    };
    default = {
      windows = false;
    };
  };
}
