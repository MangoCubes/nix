{
  username,
  ...
}:
{
  # When using home-manager podman, this option must be enabled
  virtualisation.podman.enable = true;

  home-manager.users."${username}" =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      podman-watcher = import ./podman/podman-watcher.nix {
        inherit (pkgs)
          rustPlatform
          fetchFromGitHub
          pkg-config
          lib
          glib
          pango
          libxkbcommon
          ;
      };
      services = builtins.map (s: "podman-${s}.service") config.custom.podman.containers;
      podmanStatus = pkgs.writeShellScriptBin "podman-status" ''
        ${podman-watcher}/bin/podman-watcher ${builtins.concatStringsSep " " services}
      '';
    in
    {
      imports = [ ./podman/options.nix ];
      home.packages = with pkgs; [
        dive # look into podman image layers
        podman-tui # status of containers in the terminal
        podman-compose # start group of containers for dev
        rootlesskit
        podmanStatus
      ];
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
      programs.bash.shellAliases = {
        ubuntu = "podman run --rm -it ubuntu bash";
        pcu = "podman compose up -d";
        pcul = "podman compose up -d && podman compose logs -f";
        pcl = "podman compose logs -f";
        pcd = "podman compose down";
        pcdv = "podman compose down -v";
        pcr = "podman compose restart";
        pcrv = "podman compose down -v && podman compose up -d";
        pcrvl = "podman compose down -v && podman compose up -d && podman compose logs -f";
      };
    };
}
