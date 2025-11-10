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
        default = {
          windows = false;
        };
      };
    };
    default = {
      features.windows = false;
    };
  };
}
