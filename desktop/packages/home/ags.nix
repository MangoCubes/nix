{
  unstable,
  inputs,
  ...
}:
{
  imports = [ inputs.ags.homeManagerModules.default ];
  programs.ags = {
    enable = true;

    configDir = inputs.agsWidget;

    # additional packages to add to gjs's runtime
    extraPackages = (
      with inputs.ags.packages.${unstable.stdenv.hostPlatform.system};
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
