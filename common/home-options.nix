{ lib, ... }:
{
  options.custom = lib.mkOption {
    type = lib.types.submodule {
      options.features = lib.mkOption {
        type = lib.types.submodule {
          options.windows = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      };
    };
    default = {
      features.windows = false;
    };
  };
}
