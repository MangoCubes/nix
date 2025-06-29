{ pkgs, lib, ... }:
let
  printProfile = { name, ... }: ''echo "${name}"'';
  openBrowser =
    { name, ... }:
    ''if [ $@ == "${name}" ]; then coproc (firefox -P "${name}" > /dev/null 2>&1); exit 0; fi'';
  envs = (import ../firefox/profiles.nix);
  rofi-browser = pkgs.writeShellScriptBin "rofi-browser" ''
    if [ $# -eq 0 ]
      then
        ${lib.strings.concatStringsSep "\n" (map printProfile envs)}
      else
        ${lib.strings.concatStringsSep "\n" (map openBrowser envs)}
        (exec mullvad-browser $@ &> /dev/null &); exit 0;
    fi
  '';
in
{
  home.packages = [ rofi-browser ];
}
