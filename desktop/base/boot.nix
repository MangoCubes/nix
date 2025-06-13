{ inputs, device, ... }:
{
  imports = [ inputs.grub2-themes.nixosModules.default ];
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
