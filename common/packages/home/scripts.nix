{
  pkgs,
  ...
}:
let
  detached = pkgs.writeShellScriptBin "d" ''
    ("$@" > /dev/null 2>&1 &)
  '';
  temp = pkgs.writeShellScriptBin "temp" ''
    tempdir=$(mktemp -d "${"TMPDIR:-/tmp/"}$(basename $0).XXXXXXXXXXXX")
    cd $tempdir
  '';
  rebuild = pkgs.writeShellScriptBin "rebuild" (builtins.readFile ./scripts/rebuild.sh);
in
{
  home.packages = [
    detached
    rebuild
    temp
  ];
}
