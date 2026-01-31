{ pkgs, config, ... }:
{
  programs.bash.shellAliases.xdgl = "for p in \${XDG_DATA_DIRS//:/ }; do   find $p/applications -name \'*.desktop\' ; done";
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
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [
          "gtk"
          "gnome"
        ];
      };
    };
  };
}
