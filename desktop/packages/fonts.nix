{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.noto
    (callPackage ./fonts/bank-gothic.nix { })
  ];
}
