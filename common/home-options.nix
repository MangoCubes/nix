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
      options.bookmarks = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options.path = lib.mkOption {
              type = lib.types.str;
            };
            options.keys = lib.mkOption {
              type = lib.types.nonEmptyListOf lib.types.str;
            };
          }
        );
        default = { };
      };
    };
    default = {
      windows = false;
    };
  };
}
