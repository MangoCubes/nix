# WSID: ID of the workspace with the name "config"
WSID=$(@findwsid@ config)
niri msg action focus-workspace config
niri msg -j windows | @jq@ -e ".[] | select(.workspace_id == $WSID and .title == \"NixConfig\")" > /dev/null || rofi-env NixConfig;
