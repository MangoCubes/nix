{ lib, ... }:
{
  options.custom.backups = lib.mkOption {
    type = lib.types.submodule {
      options.backblaze = lib.mkOption {
        type = (lib.types.listOf lib.types.str);
      };
    };
    default = {
      backblaze = [ ];
    };
  };
}
