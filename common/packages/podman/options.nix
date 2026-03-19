{ lib, ... }:
{
  options.custom.podman = lib.mkOption {
    type = lib.types.submodule {
      options.containers = lib.mkOption {
        type = (lib.types.listOf lib.types.str);
      };
      options.dns = lib.mkOption {
        type = lib.types.str;
      };
      options.dnsProvider = lib.mkOption {
        type = lib.types.str;
      };
      options.subnet = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
}
