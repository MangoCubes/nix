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
        ../../common/packages/home/nixvim.nix
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
        ../packages/home/fnott.nix
        ../packages/home/ags.nix
        ../packages/home/kde.nix
        ../packages/home/korean.nix
        ../packages/home/polkit.nix
        ../packages/home/mullvad-browser.nix
        ../packages/home/wlr-which-key.nix
        ../packages/home/nextcloud.nix
        ../packages/home/periodic.nix
        ../packages/home/keepassxc.nix
        ../packages/home/gocryptfs.nix
        ../packages/home/rclone-server-main.nix
      ];

      xdg.configFile."configMedia" = {
        source = "${inputs.secrets.res}/media";
        recursive = true;
      };
      home = {
        packages =
          (with unstable; [
            kdiff3
            libreoffice-qt
            wl-clipboard
            adwaita-icon-theme
            jmtpfs
            vlc
            sshpass
            sops
            devenv
            # cinny-desktop
          ])
          ++ (with pkgs; [
            tor-browser
          ])
          ++ (with inputs.nix-alien.packages.${system}; [
            nix-alien
          ]);
      };
    };
}
