{ lib, config, ... }:
let
  absPath = lib.types.addCheck lib.types.str (lib.hasPrefix "/");
  hostPath = lib.types.addCheck lib.types.str (
    path: path != "" && !(builtins.elem ".." (lib.splitString "/" path))
  );
  podmanDir = "${config.home.homeDirectory}/.podman";
  path = path: if lib.hasPrefix "/" path then path else "${podmanDir}/${path}";
  required = type: description: lib.mkOption { inherit type description; };
  optional =
    type: default: description:
    lib.mkOption { inherit type default description; };
  list = type: optional (lib.types.listOf type) [ ];
  nullable = type: optional (lib.types.nullOr type) null;
  attrs = type: optional (lib.types.attrsOf type) { };
  bool = optional lib.types.bool;
in
{
  options.custom.podman = {
    containers = attrs (lib.types.submodule {
      options = {
        activation = optional lib.types.lines "" "Commands to execute on activation";
        network = optional (lib.types.either lib.types.str (
          lib.types.listOf lib.types.str
        )) "proxy" "Network for the container";
        volumes = list absPath "Directories inside the container to store in automatically named podman volumes";
        mounts = list (lib.types.submodule (mount: {
          options = {
            inside = required absPath "Path inside the container";
            outside = (
              required hostPath "Path outside the container, relative to ~/.podman unless absolute"
              // {
                apply = path;
              }
            );
            create = bool (lib.hasPrefix "${podmanDir}/" mount.config.outside) "Create the path outside the container as a directory if it does not exist";
            readOnly = bool false "Mount as read-only";
          };
        })) "Paths outside the container to bind mount into the container";
        backup = list hostPath (
          "Directories outside the container to include in backups"
          // {
            apply = builtins.map path;
          }
        );
        ports = list lib.types.str "Ports to expose";
        environment = attrs (lib.types.oneOf [
          lib.types.str
          lib.types.int
          lib.types.bool
        ]) "Environment variables for the container";
        image = required lib.types.str "Image for the container";
        domain = nullable (lib.types.listOf (
          lib.types.submodule {
            options = {
              url = nullable lib.types.str null;
              rule = nullable lib.types.str null;
              certResolver = nullable lib.types.str null;
              port = required lib.types.port null;
              extraRouterConfig = optional lib.types.attrs { } null;
              extraServiceConfig = optional lib.types.attrs { } null;
            };
          }
        )) "Traefik routing configurations for the container";
        entrypoint = nullable lib.types.str "Entrypoint command/script for the container";
        environmentFile = list (lib.types.either lib.types.str lib.types.path) "Paths to environment files";
        labels = attrs lib.types.str "Container labels";
        dropCapabilities = list lib.types.str "Linux capabilities to drop";
        extraPodmanArgs = list lib.types.str "Extra args to pass to podman";
        addCapabilities = list lib.types.str "Linux capabilities to add";
        devices = list lib.types.str "Host devices to mount into the container";
        needRoot = bool false "If true, then run with container owner's permission";
        dependsOn = nullable (lib.types.listOf lib.types.str) "List of containers this container depends on";
        exec = nullable lib.types.str "Command to execute inside the container";
        autoStart = bool true "Whether to automatically start the container on boot";
        daily = nullable lib.types.str "Daily command to execute via a systemd timer";
        ip4 = nullable lib.types.str "Static IPv4 address for the container";
        vpn = nullable lib.types.str "VPN key to use with gluetun";
        uid = nullable lib.types.ints.unsigned "User inside the container that owns newly created disk paths";
        postgresql = nullable (lib.types.submodule {
          options = {
            image = required lib.types.str null;
            secretEnvPath = required lib.types.str null;
          };
        }) "PostgreSQL container to create alongside, named postgresql-<name>";
        redis = bool false "Redis container to create alongside, named redis-<name>";
      };
    }) null;
    dns = required lib.types.str null;
    dnsProvider = required lib.types.str null;
    subnet = required lib.types.str null;
  };
}
