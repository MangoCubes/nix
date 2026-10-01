PATTERN="Passwords.sync-conflict-*.kdbx"
for file in "$HOME/Sync/Passwords"/$PATTERN; do
    if [[ -f "$file" ]]; then
        echo "Processing file: $file"
        keepassxc-cli merge -s "$HOME/Sync/Passwords/Passwords.kdbx" "$file"
    fi
done
