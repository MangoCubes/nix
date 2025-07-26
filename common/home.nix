{ username, ... }:
{
  home-manager.users."${username}" =
    {
      pkgs,
      unstable,
      inputs,
      config,
      ...
    }:
    {
      imports = [
        ./packages/home/podman/syncthing.nix
        ./packages/home/bash.nix
        ./packages/home/yazi.nix
        ./packages/home/scripts.nix
      ];

      home.packages = (
        with pkgs;
        [
          nix-search-cli
          nix-tree
          btop
          fzf
          ouch
          rclone
        ]
      );
      home.stateVersion = "24.11";
    };
}
