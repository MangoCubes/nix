{ pkgs, config, ... }:
{
  home.packages = [
    (pkgs.writeScriptBin "xdgl" (builtins.readFile ./xdg/xdgl.sh))
  ];
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
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [
          "kde"
          "gtk"
        ];
      };
    };
  };
}
