{ pkgs, ... }:
{
  home.packages = [
    pkgs.dconf
    pkgs.bottles
  ];
}
