{ lib, ... }:
{
  options.custom.device = lib.mkOption {
    type = lib.types.submodule {
      options.type = lib.mkOption {
        type = lib.types.enum [
          "desktop"
          "laptop"
          "server"
          "vm"
        ];
      };
      options.emacsScale = lib.mkOption {
        type = lib.types.number;
        default = 1;
      };
      options.scale = lib.mkOption {
        type = lib.types.number;
        default = 1;
      };
      options.presentation = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      options.monitors = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options.x = lib.mkOption {
              type = lib.types.int;
            };
            options.y = lib.mkOption {
              type = lib.types.int;
            };
          }
        );
        default = [ ];
      };
    };
  };
}
