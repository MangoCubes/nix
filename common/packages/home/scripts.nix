{
  pkgs,
  ...
}:
let
  detached = pkgs.writeShellScriptBin "d" ''
    ("$@" > /dev/null 2>&1 &)
  '';

in
{
  home.packages = [
    detached
  ];
}
