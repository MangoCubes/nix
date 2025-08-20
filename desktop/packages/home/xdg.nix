{ pkgs, ... }:
{
  programs.bash.shellAliases.xdgl = "for p in \${XDG_DATA_DIRS//:/ }; do   find $p/applications -name \'*.desktop\' ; done";
  xdg = {
    mime.enable = true;
    mimeApps.enable = true;
    portal = {
      enable = true;
      configPackages = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
      ];
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
      ];
      config = {
        common.default = [
          "kde"
        ];
      };
    };
  };
}
