{
  pkgs,
  config,
  lib,
  ...
}:
let
  termFileChooser = pkgs.writeShellScript "term-file-chooser" (
    builtins.replaceStrings [ "@terminal@" ] [ config.custom.terminal.program ] (
      builtins.readFile ./xdg/term-file-chooser.sh
    )
  );
  mimeInfo =
    {
      type,
      globs,
      comment,
    }:
    ''
      <?xml version="1.0" encoding="utf-8"?>
        <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="${type}">
          ${lib.concatMapStringsSep "\n" (glob: "<glob pattern=\"${glob}\"/>") globs}
          <comment>${comment}</comment>
        </mime-type>
      </mime-info>
    '';
  nvim-mailto = pkgs.writeShellScriptBin "nvim-mailto" ''
    MAILTO_URI="''${1:-mailto:}" exec nvim -c 'lua vim.cmd.Mailto(vim.env.MAILTO_URI)'
  '';
in
{
  home = {
    packages = [
      (pkgs.writeScriptBin "xdgl" (builtins.readFile ./xdg/xdgl.sh))
      nvim-mailto
    ];
    activation.updateMimeDb = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "$HOME/.local/share/mime/packages" ]; then
        ${pkgs.shared-mime-info}/bin/update-mime-database "$HOME/.local/share/mime"
      fi
    '';
  };
  xdg = {
    dataFile."mime/packages/sops-encrypted.xml".text = mimeInfo {
      type = "text/sops-encrypted";
      globs = [ "*.enc.*" ];
      comment = "Secret protected by SOPS";
    };
    dataFile."mime/packages/orgmode.xml".text = mimeInfo {
      type = "text/org";
      globs = [ "*.org" ];
      comment = "OrgMode documents";
    };
    mimeApps.defaultApplications = {
      "text/sops-encrypted" = "sops-nvim.desktop";
      "text/org" = "neovim-new.desktop";
      "x-scheme-handler/mailto" = "nvim-mailto.desktop";
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
    desktopEntries.nvim-mailto = {
      name = "Neovim (mailto)";
      exec = (config.custom.terminal.genCmd { command = "nvim-mailto %u"; });
      terminal = true;
      mimeType = [ "x-scheme-handler/mailto" ];
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
