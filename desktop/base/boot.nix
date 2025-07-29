{
  inputs,
  device,
  pkgs,
  ...
}:
{
  imports = [
    inputs.grub2-themes.nixosModules.default
  ];

  boot.plymouth = {
    enable = true;
    theme = "target";
    themePackages = with pkgs; [
      # By default we would install all themes
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "target" ];
      })
    ];
  };

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
