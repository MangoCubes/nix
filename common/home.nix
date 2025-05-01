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
    let
      keyFile = "${config.home.homeDirectory}/Sync/Secrets/age.txt";
    in
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
        ./packages/home/podman/syncthing.nix
        ./packages/home/nixvim.nix
        ./packages/home/bash.nix
        ./packages/home/yazi.nix
      ];

      home.packages = (
        with pkgs;
        [
          nix-search-cli
          nix-tree
          btop
          fzf
          p7zip
        ]
      );

      sops.age.keyFile = keyFile;
      home = {
        stateVersion = "24.11";
        sessionVariables = {
          "SOPS_AGE_KEY_FILE" = keyFile;
        };
      };
    };
}
