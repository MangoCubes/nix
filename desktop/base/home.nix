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
      home.activation.temp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${config.home.homeDirectory}/Temp
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
        ../packages/home/hyprland-new.nix
        ../packages/home/ags.nix
        ../packages/home/dolphin.nix
      ];

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
        file.".config/configMedia" = {
          source = "${inputs.secrets.res}/media";
          recursive = true;
        };
      };
    };
}
