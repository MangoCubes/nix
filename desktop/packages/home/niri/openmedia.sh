WSID=$(@findwsid@ media)
niri msg action focus-workspace media
niri msg -j windows | @jq@ -e ".[] | select(.workspace_id == $WSID and .title == \"ampterm\")" > /dev/null || @amptermCmd@
