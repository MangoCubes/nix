{ lib, ... }:
{
  # Create a new option named `custom.networking`...
  options.custom.networking = lib.mkOption {
    # With a type of `submodule` (a set of options)
    type = lib.types.submodule {
      # Create a new option named `primary`...
      options.primary = lib.mkOption {
        # With a type of string
        type = lib.types.str;
      };
      options.secondary = lib.mkOption {
        # With a type of string
        type = lib.types.str;
      };
    };
    default = {
      primary = "";
      secondary = "";
    };
  };
}
