{
  username,
  lib,
  config,
  ...
}:
let
  isPodmanUsed =
    config.custom.podman.enable
    || config.home-manager.users."${username}".services.podman.containers != { };
in
{
  options.custom.podman.enable = lib.mkEnableOption "Enable podman";

  config = {
    # When using home-manager podman, this option must be enabled
    virtualisation.podman.enable = isPodmanUsed;

    home-manager.users."${username}" =
      {
        pkgs,
        config,
        lib,
        inputs,
        ...
      }:
      let
        podman-watcher = pkgs.callPackage ./podman/podman-watcher.nix { };
        mkContainer = c: (import ./podman/podman.nix c) { inherit lib config pkgs; };
        containerConfigs = builtins.attrValues (
          builtins.mapAttrs (name: c: mkContainer (c // { inherit name; })) config.custom.podman.containers
        );
        # Name of VPNs to use
        vpnKeys = lib.unique (
          builtins.filter (v: v != null) (
            builtins.catAttrs "vpn" (builtins.attrValues config.custom.podman.containers)
          )
        );
        vpnConfigs = builtins.map (
          vpn:
          mkContainer {
            name = "gluetun-${vpn}";
            image = "qmcgaw/gluetun:latest";
            dependsOn = null;
            addCapabilities = [
              "NET_ADMIN"
              "NET_RAW"
            ];
            devices = [ "/dev/net/tun:/dev/net/tun" ];
            entrypoint = ''
              export SERVER_COUNTRIES=$(/gluetun-entrypoint format-servers -protonvpn -format json | grep country | uniq | shuf | head -n 1 | sed -nE 's/.+"country": "(.+)".+/\1/p');
              /gluetun-entrypoint
            '';
            environmentFile = [ config.sops.secrets."gluetun-${vpn}".path ];
          }
        ) vpnKeys;
        # All container configs in a form of list
        allConfigs = containerConfigs ++ vpnConfigs;
        mergeAll = key: lib.mkMerge (builtins.catAttrs key allConfigs);
        # List of all container services
        services = builtins.map (name: "podman-${name}.service") (
          (builtins.attrNames config.custom.podman.containers)
          ++ (builtins.map (vpn: "gluetun-${vpn}") vpnKeys)
        );
        podmanStatus = pkgs.writeShellScriptBin "podman-status" ''
          ${podman-watcher}/bin/podman-watcher ${builtins.concatStringsSep " " services}
        '';
        podmanStart = pkgs.writeShellScriptBin "podman-start" (
          builtins.concatStringsSep "\n" (
            builtins.map (s: ''(echo "Starting ${s}..." && systemctl --user start ${s} &); '') services
          )
        );
        secrets = name: {
          "gluetun-${name}" = inputs.secrets.common.packages.home.gluetun { inherit name; };
        };
      in
      {
        imports = [ ./podman/options.nix ];
        config = lib.mkMerge [
          {
            custom.podman = {
              dns = "107.175.189.176";
              dnsProvider = "10.10.0.53";
              subnet = "10.10.0.0/24";
            };
            custom.shell.aliases = lib.mkIf isPodmanUsed {
              ubuntu = "podman run --rm -it ubuntu bash";
              docker = "podman $@";
              pcu = "podman compose up -d";
              pcul = "podman compose up -d && podman compose logs -f";
              pcl = "podman compose logs -f";
              pcd = "podman compose down";
              pcdv = "podman compose down -v";
              pcr = "podman compose restart";
              pcrv = "podman compose down -v && podman compose up -d";
              pcrvl = "podman compose down -v && podman compose up -d && podman compose logs -f";
            };
            services.podman.containers = mergeAll "container";
          }
          (lib.mkIf isPodmanUsed {
            sops.secrets = lib.mkMerge (builtins.map secrets vpnKeys);
            services.podman = {
              autoUpdate.enable = true;
              enable = true;
              settings = {
                storage = {
                  storage.driver = "overlay";
                  storage.options.overlay.mount_program = "${pkgs.fuse-overlayfs}/bin/fuse-overlayfs";
                };
              };
            };
            home.packages = (
              with pkgs;
              [
                dive # look into podman image layers
                podman-tui # status of containers in the terminal
                podman-compose # start group of containers for dev
                rootlesskit
                podmanStatus
                podmanStart
              ]
            );
            home.activation = mergeAll "activation";
            systemd.user.timers = (
              lib.mkMerge [
                (mergeAll "timer")
                {
                  podman-prune = {
                    Unit.Description = "Prune unused Podman data";
                    Timer = {
                      OnCalendar = "daily";
                      Persistent = true;
                    };
                    Install.WantedBy = [ "timers.target" ];
                  };
                }
              ]
            );
            systemd.user.services = (
              lib.mkMerge [
                (mergeAll "service")
                {
                  podman-prune = {
                    Unit.Description = "Prune unused Podman data";
                    Service = {
                      Type = "oneshot";
                      ExecStart = "${pkgs.podman}/bin/podman system prune -a";
                    };
                  };
                }
              ]
            );
          })
        ];
      };
  };
}
