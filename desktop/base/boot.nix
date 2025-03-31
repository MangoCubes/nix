{ inputs, ... }:{
  imports = [ inputs.grub2-themes.nixosModules.default ];
  boot.loader.grub2-theme = {
    enable = true;
    theme = "stylish";
    footer = true;
    customResolution = "1920x1080";  # Optional: Set a custom resolution
  };
}
