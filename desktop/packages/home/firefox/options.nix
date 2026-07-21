{ lib, ... }:
{
  options.custom.browser = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          trustedUrls = lib.mkOption {
            type = (lib.types.listOf lib.types.str);
            default = [ ];
          };
        };
      }
    );
  };
}
