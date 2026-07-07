#!/usr/bin/env bash

DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

IFS=':' read -ra DIR_ARRAY <<< "$DATA_DIRS"

for dir in "${DIR_ARRAY[@]}"; do
    find -L "$dir" -name "*.desktop" 2>/dev/null
done
