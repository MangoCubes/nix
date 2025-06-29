{ pkgs, ... }:
let
  rofi-search = pkgs.writeShellScriptBin "rofi-search" ''${pkgs.python3}/bin/python ${./rofi-search.py}'';
in
{
  home.packages = [ rofi-search ];
}
