{ pkgs, config, ... }:
{
  home.packages = [
    (pkgs.writeScriptBin "xdgl" (builtins.readFile ./xdg/xdgl.sh))
  ];
  xdg = {
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
