{ pkgs, ... }:
{
  home.packages = [
    pkgs.dconf
    (pkgs.bottles.override { removeWarningPopup = true; })
  ];
}
