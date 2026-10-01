{
  pkgs,
  config,
  lib,
  ...
}:
let
  termFileChooser = pkgs.writeShellScript "term-file-chooser" ''
    set -e
    multiple="$1"
    directory="$2"
    save="$3"
    path="$4"
    out="$5"

    args=()

    if [ "$save" = "1" ]; then
      args+=(--chooser-file="$out")
    elif [ "$directory" = "1" ]; then
      args+=(--chooser-dir="$out")
    else
      args+=(--chooser-file="$out")
    fi

    if [ -n "$path" ] && [ -e "$path" ]; then
      args+=("$path")
    fi

    exec ${config.custom.terminal.program} --title=file_chooser -e yazi "''${args[@]}"
  '';
in
{
  home = {
    packages = [
      (pkgs.writeScriptBin "xdgl" (builtins.readFile ./xdg/xdgl.sh))
    ];
    activation.updateMimeDb = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "$HOME/.local/share/mime/packages" ]; then
        ${pkgs.shared-mime-info}/bin/update-mime-database "$HOME/.local/share/mime"
      fi
    '';
  };
  xdg = {
    dataFile."mime/packages/sops-encrypted.xml".text = ''
      <?xml version="1.0" encoding="utf-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="text/sops-encrypted">
        <glob pattern="*.enc.txt"/>
        <glob pattern="*.enc.conf"/>
        <comment>Secret protected by SOPS</comment>
      </mime-type>
      </mime-info>
    '';
    mimeApps.defaultApplications = {
      "text/sops-encrypted" = "sops-nvim.desktop";
    };
    desktopEntries = {
      sops-nvim = {
        name = "SOPS Neovim";
        genericName = "Secret Editor";
        exec = "sops %f";
        terminal = true;
        mimeType = [
          "text/sops-encrypted"
        ];
      };
    };

    mimeApps.defaultApplications."application/json" = "neovim-new.desktop";
    desktopEntries.neovim-new = {
      name = "Neovim Terminal";
      genericName = "Text Editor";
      exec = (config.custom.terminal.genCmd { command = "nvim %F"; });
      terminal = true;
    };
    mime.enable = true;
    mimeApps.enable = true;
    portal = {
      enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
      ];
      config = {
        common = {
          default = [
            "kde"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [
            "termfilechooser"
          ];
        };
      };
    };
    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${termFileChooser}
    '';
  };
}
