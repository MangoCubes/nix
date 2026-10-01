syncthing_state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/syncthing"
syncthing_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/syncthing"

if [[ -e "$syncthing_state_dir/config.xml" || ! -e "$syncthing_config_dir/config.xml" ]]; then
    syncthing_dir="$syncthing_state_dir"
else
    syncthing_dir="$syncthing_config_dir"
fi

config_file="$syncthing_dir/config.xml"
if [[ ! -f "$config_file" ]]; then
    echo "Error: Syncthing config.xml not found at $config_file"
    exit 1
fi

API_KEY=$(< "@apiKeyPath@")

@xmlstarlet@ ed -L -u "/configuration/gui/apikey" -v "$API_KEY" "$config_file"
@xmlstarlet@ ed -L -u "/configuration/defaults/folder/@path" -v "@syncPath@" "$config_file"
@xmlstarlet@ ed -L -u "/configuration/defaults/ignores/line" -v "#include ./.ignore.txt" "$config_file"
