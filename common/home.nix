{ username, ... }:
{
  # This specified home-manager options
  # Anything set in this applies to the user specified only
  # In this case, `username` is "main" (defined in `specialArgs` in flake.nix)
  # Anything in this does not affect other users (such as root)
  # This is basically `configuration.nix`, but just for user "main", and does not have certain options that would usually require root
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
        ./packages/home/nixvim.nix
        ./packages/home/atuin.nix
        ./packages/home/podman/syncthing.nix
        ./packages/home/bash.nix
        ./packages/home/yazi.nix
        ./packages/home/scripts.nix
        ./home-options.nix
      ];

      home.packages =
        (with pkgs; [
          nh
          nix-search-cli
          nix-tree
          btop
          fzf
          ouch
          rclone
        ])
        ++ (with pkgs.unixtools; [ xxd ]);

      # This value should be set to what you had when you initially installed NixOS
      home.stateVersion = "24.11";
    };
}
