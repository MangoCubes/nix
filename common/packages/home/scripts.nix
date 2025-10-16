{
  pkgs,
  ...
}:
let
  detached = pkgs.writeShellScriptBin "d" ''
    ("$@" > /dev/null 2>&1 &)
  '';
  rebuild = pkgs.writeShellScriptBin "rebuild" (builtins.readFile ./scripts/rebuild.sh);
in
{
  home.packages = [
    detached
    rebuild
  ];
}
