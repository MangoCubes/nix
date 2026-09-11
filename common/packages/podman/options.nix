{ lib, ... }:
{
  options.custom.podman = lib.mkOption {
    type = lib.types.submodule {
      options.containers = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              activation = lib.mkOption {
                type = lib.types.lines;
                default = "";
                description = "Commands to execute on activation";
              };
              network = lib.mkOption {
                type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                default = "proxy";
                description = "Network for the container";
              };
              name = lib.mkOption {
                type = lib.types.str;
                description = "Name of the container";
              };
              volumes = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Volumes to mount to the container";
              };
              ports = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Ports to expose";
              };
              environment = lib.mkOption {
                type = lib.types.attrsOf (
                  lib.types.either lib.types.str (lib.types.either lib.types.int lib.types.bool)
                );
                default = { };
                description = "Environment variables for the container";
              };
              image = lib.mkOption {
                type = lib.types.str;
                description = "Image for the container";
              };
              domain = lib.mkOption {
                type = lib.types.nullOr (
                  lib.types.listOf (
                    lib.types.submodule {
                      options = {
                        routerName = lib.mkOption {
                          type = lib.types.str;
                          description = "Traefik router name";
                        };
                        type = lib.mkOption {
                          type = lib.types.enum [
                            "global"
                            "local"
                            "auto"
                          ];
                          description = ''Routing type: "global" (globally accessible), "local" (locally named), or "auto" (local and automatically generated)'';
                        };
                        url = lib.mkOption {
                          type = lib.types.str;
                          description = "Host domain to access the container";
                        };
                        port = lib.mkOption {
                          type = lib.types.port;
                          description = "Port of the container";
                        };
                      };
                    }
                  )
                );
                default = null;
                description = "Traefik routing configurations for the container";
              };
              user = lib.mkOption {
                type = lib.types.nullOr (lib.types.either lib.types.str lib.types.int);
                default = null;
                description = "User to run the container as";
              };
              entrypoint = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Entrypoint command/script for the container";
              };
              environmentFile = lib.mkOption {
                type = lib.types.listOf (lib.types.either lib.types.str lib.types.path);
                default = [ ];
                description = "Paths to environment files";
              };
              labels = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = { };
                description = "Container labels";
              };
              dropCapabilities = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Linux capabilities to drop";
              };
              extraPodmanArgs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Extra args to pass to podman";
              };
              addCapabilities = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Linux capabilities to add";
              };
              devices = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Host devices to mount into the container";
              };
              needRoot = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "If true, then run with container owner's permission";
              };
              dependsOn = lib.mkOption {
                type = lib.types.nullOr (lib.types.listOf lib.types.str);
                default = null;
                description = "List of containers this container depends on";
              };
              exec = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Command to execute inside the container";
              };
              autoStart = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to automatically start the container on boot";
              };
              daily = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Daily command to execute via a systemd timer";
              };
              ip4 = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Static IPv4 address for the container";
              };
            };
          }
        );
        default = [ ];
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
