{ pkgs, ... }:
# Not like other scripts in this folder
# This is a script that opens up a prompt and takes in user input
let
  rofi-input = pkgs.writeShellScriptBin "rofi-input" ''
    args=""
    if [[ "$1" == "-p" ]]; then
        shift
        args="$*"
    	if [[ -z "$args" ]]; then
            rofi -dmenu -password -p Input -theme-str 'listview { enabled: false; }'
        else
            rofi -dmenu -password -p "$args" -theme-str 'listview { enabled: false; }'
        fi
    else
        args="$*"
    	if [[ -z "$args" ]]; then
            rofi -dmenu -p Input -theme-str 'listview { enabled: false; }'
        else
            rofi -dmenu -p "$args" -theme-str 'listview { enabled: false; }'
        fi
    fi
  '';
in
{
  home.packages = [ rofi-input ];
}
