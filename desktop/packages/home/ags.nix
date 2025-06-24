{ unstable, inputs, ... }:
{
  imports = [ inputs.ags.homeManagerModules.default ];
  programs.ags = {
    enable = true;

    # symlink to ~/.config/ags
    configDir = ./ags;

    # additional packages to add to gjs's runtime
    extraPackages = (
      with inputs.ags.packages.${unstable.system};
      [
        battery
        mpris
        wireplumber
        notifd
        tray
      ]
    );
    systemd.enable = true;
  };
}
