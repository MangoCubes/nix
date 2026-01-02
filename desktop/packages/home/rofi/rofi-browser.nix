{ pkgs, lib, ... }:
let
  printProfile =
    {
      name,
      alias ? null,
      ...
    }:
    if alias == null then
      ''echo "${name}"''
    else
      ''echo "${name} (${builtins.concatStringsSep ", " alias})"'';
  openBrowser =
    { name, ... }:
    ''if [ $first == "${name}" ]; then coproc (profilebrowser "${name}" > /dev/null 2>&1); exit 0; fi'';
  envs = (import ../firefox/profiles.nix);
  rofi-browser = pkgs.writeShellScriptBin "rofi-browser" ''
    if [ $# -eq 0 ]
      then
        ${lib.strings.concatStringsSep "\n" (map printProfile envs)}
      else
        first=''${1%% *}
        ${lib.strings.concatStringsSep "\n" (map openBrowser envs)}
        (exec browser $@ &> /dev/null &); exit 0;
    fi
  '';
in
{
  home.packages = [ rofi-browser ];
}
