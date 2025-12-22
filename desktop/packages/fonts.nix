{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    nerd-fonts.noto
    (callPackage ./fonts/bank-gothic.nix { })
  ];
}
