{
  username,
  device,
  lib,
  ...
}:
{
  imports = [
    ./multiuser.nix
  ];
  # This specified home-manager options
  # Anything set in this applies to the user specified only
  # In this case, `username` is "main" (defined in `specialArgs` in flake.nix)
  # Anything in this does not affect other users (such as root)
  # This is basically `configuration.nix`, but just for user "main", and does not have certain options that would usually require root
  home-manager.users = {
    "${username}" =
      {
        pkgs,
        unstable,
        inputs,
        config,
        ...
      }:
      let
        mount = (import ./packages/home/rclone.nix);
      in
      {
        imports = [
          (mount "koofr")
          (mount "2tb")
          (mount "drive")
          ./packages/home/atuin.nix
          ./home-options.nix
        ]
        ++ (
          if device.type != "vm" then
            [
              ./packages/home/yazi.nix
              ./packages/home/syncthing.nix
              ./packages/home/neovim.nix
            ]
          else
            [ ]
        );

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
        home.sessionVariables =
          let
            envVars =
              { sets, prefix }:
              lib.mapAttrs' (name: value: lib.nameValuePair (lib.toUpper "${prefix}_${name}") value) sets;
            colours = (import ./colours.nix);
          in
          (envVars {
            sets = colours.base;
            prefix = "COLOUR";
          })
          // (envVars {
            sets = colours.withTransparency;
            prefix = "TRANSPARENT";
          });

        # This value should be set to what you had when you initially installed NixOS
        home.stateVersion = "24.11";
      };
    test =
      { osConfig, ... }:
      {
        imports = [
          ./packages/home/zsh.nix
        ];
        home.stateVersion = osConfig.system.stateVersion;
      };
    access =
      { osConfig, ... }:
      {
        imports = [
          ./packages/home/zsh.nix
        ];
        home.stateVersion = osConfig.system.stateVersion;
      };
  };
}
