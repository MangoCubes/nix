{ pkgs, ... }:
# Not like other scripts in this folder
# This is a script that opens up a prompt and takes in user input
let
  rofi-input = pkgs.writeShellScriptBin "rofi-input" ''
    if [ "$#" -eq 0 ]; then
      rofi -dmenu -p Input -theme-str 'listview { enabled: false; }'
    else
      rofi -dmenu -p $@ -theme-str 'listview { enabled: false; }'
    fi
  '';
in
{
  home.packages = [ rofi-input ];
}
