{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Noto"
      ];
    })
    (callPackage ./fonts/bank-gothic.nix { })
  ];
}
