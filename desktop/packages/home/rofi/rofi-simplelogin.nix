{
  inputs,
  pkgs,
  ...
}:
let
  rofi-sl = pkgs.writeShellScriptBin "rofi-sl" ''${pkgs.python3}/bin/python ${./simplelogin/simplelogin.py} $@'';
in
{
  imports = [
    inputs.secrets.hm.simplelogin
  ];
  home.packages = [ rofi-sl ];
}
