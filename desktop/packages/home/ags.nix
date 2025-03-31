{ pkgs, inputs, ... }:
{
  imports = [ inputs.ags.homeManagerModules.default ];
  programs.ags = {
    enable = true;

    # symlink to ~/.config/ags
    configDir = ./ags;

    # additional packages to add to gjs's runtime
    extraPackages = (
      with inputs.ags.packages.${pkgs.system};
      [
        battery
        hyprland
        mpris
        wireplumber
      ]
    );
    systemd.enable = true;
  };
}
