{ lib, ... }:

{
  options.custom.web = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          content = lib.mkOption {
            type = lib.types.str;
          };
          type = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          headers = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
          };
          index = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      }
    );
  };
}
