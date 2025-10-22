{ lib, ... }:
{
  # Create a new option named `custom`...
  options.custom = lib.mkOption {
    # With a type of `submodule` (a set of options)
    type = lib.types.submodule {
      # Create a new option named `networking`...
      options.networking = lib.mkOption {
        # With a type of `submodule` (a set of options)
        type = lib.types.submodule {
          # Create a new option named `primary`...
          options.primary = lib.mkOption {
            # With a type of string
            type = lib.types.str;
            # That defaults to an empty string
            default = "";
          };
          options.secondary = lib.mkOption {
            type = lib.types.str;
          };
        };
        default = {
          primary = "";
        };
      };
      options.features = lib.mkOption {
        type = lib.types.submodule {
          options.tablet = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
        default = {
          tablet = false;
        };
      };
    };
    default = {
      features.tablet = false;
    };
  };
}
