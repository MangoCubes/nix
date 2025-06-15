{
  inputs,
  device,
  pkgs,
  ...
}:
{
  imports = [
    inputs.grub2-themes.nixosModules.default
    inputs.mikuboot.nixosModules.default
  ];
  boot.plymouth =
    {
      enable = true;

    }
    // (
      # if device.presentation then
      if true then
        {
          theme = "target";
          themePackages = with pkgs; [
            # By default we would install all themes
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "target" ];
            })
          ];
        }
      else
        {
          themePackages = [ pkgs.mikuboot ];
          theme = "mikuboot";
        }
    );

  boot.loader.grub2-theme = {
    enable = true;
    theme = "stylish";
    footer = true;
    customResolution =
      let
        mon = (builtins.elemAt device.monitors 0);
      in
      "${builtins.toString mon.x}x${builtins.toString mon.y}";
  };
}
