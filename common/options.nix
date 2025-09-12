{ config, lib, ... }:
{
  # Create a new option...
  options = {
    # Named `custom`...
    custom = lib.mkOption {
      # With a type of `submodule` (a set of options)
      type = lib.types.submodule {
        # Create a new option...
        options = {
          # Named `networking`...
          networking = lib.mkOption {
            # With a type of `submodule` (a set of options)
            type = lib.types.submodule {
              # Create a new option...
              options = {
                # Named `primary`...
                primary = lib.mkOption {
                  # With a type of string
                  type = lib.types.str;
                  # That defaults to an empty string
                  default = "";
                };
                secondary = lib.mkOption {
                  type = lib.types.str;
                };
              };
            };
            default = {
              primary = "";
            };
          };
          features = lib.mkOption {
            type = lib.types.submodule {
              options = {
                tablet = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
              };
            };
            default = {
              tablet = false;
            };
          };
        };
      };
      default = {
        features.tablet = false;
      };
    };
  };
}
