{ pkgs, ... }:
{
  programs.bash.shellAliases.xdgl = "for p in \${XDG_DATA_DIRS//:/ }; do   find $p/applications -name \'*.desktop\' ; done";
  xdg = {
    mimeApps = {
      enable = true;
      # Determines how each file would be opened by default
      defaultApplications = {
        "application/pdf" = "mullvad-browser.desktop";
        "text/html" = "mullvad-browser.desktop";
        "x-scheme-handler/http" = "mullvad-browser.desktop";
        "x-scheme-handler/https" = "mullvad-browser.desktop";
        "inode/directory" = "yazi.desktop";
      };
    };
    portal = {
      enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-hyprland
        kdePackages.xdg-desktop-portal-kde
      ];
      config = {
        hyprland = {
          default = [
            "hyprland"
            "kde"
          ];
        };
      };
    };
  };
}
