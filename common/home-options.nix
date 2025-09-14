{ lib, ... }:
{
  options = {
    custom = lib.mkOption {
      type = lib.types.submodule {
        options = {
          podman = lib.mkOption {
            type = lib.types.submodule {
              options = {
                containers = lib.mkOption {
                  type = (lib.types.listOf lib.types.str);
                };
              };
            };
          };
        };
      };
    };
  };
}
