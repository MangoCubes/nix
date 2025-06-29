{ pkgs, ... }:
let
  rofi-env = pkgs.writeShellScriptBin "rofi-env" ''${pkgs.python3}/bin/python ${./env/env.py} $@'';
in
{
  home.packages = [ rofi-env ];
}
