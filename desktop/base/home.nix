{ username, ... }:
{
  home-manager.users."${username}" =
    {
      pkgs,
      unstable,
      inputs,
      config,
      lib,
      system,
      ...
    }:
    {
      home.activation.dirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${config.home.homeDirectory}/Temp
        mkdir -p ${config.home.homeDirectory}/LocalDocuments
        mkdir -p ${config.home.homeDirectory}/Downloads
      '';
      imports = [
        ../packages/home/cursor.nix
        ../packages/home/emacs.nix
        ../packages/home/firefox.nix
        ../packages/home/xdg.nix
        ../packages/home/kitty.nix
        ../packages/home/rofi.nix
        ../packages/home/bash.nix
        ../packages/home/accounts.nix
        ../packages/home/swww.nix
        ../packages/home/niri.nix
        ../packages/home/ags.nix
        ../packages/home/kde.nix
        ../packages/home/korean.nix
        ../packages/home/polkit.nix
      ];

      xdg.configFile."configMedia" = {
        source = "${inputs.secrets.res}/media";
        recursive = true;
      };
      xdg.configFile."keepassxc".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/keepassxc";
      home = {
        packages =
          (with unstable; [
            kdiff3
            libreoffice-qt
            wl-clipboard
            keepassxc
            adwaita-icon-theme
            jmtpfs
            vlc
            sshpass
            sops
          ])
          ++ (with pkgs; [
            mullvad-browser
            nextcloud-client
            tor-browser
            # nyxt
          ])
          ++ (with inputs.nix-alien.packages.${system}; [
            nix-alien
          ]);
      };
    };
}
