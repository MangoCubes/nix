{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "3270" ]; })
    (callPackage ./fonts/bank-gothic.nix { })
  ];
}
