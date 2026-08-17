search_dir="."
files=$(find "$search_dir" -type f -name "*sync-conflict*" -not -path "*/.stversions/*")

if [[ -z "$files" ]]; then
    echo "No files found with 'sync-conflict' in their names."
    exit 0
fi

function remove_file() {
    rm "$1"
    directory=$(dirname $1)
    while [ -d "$directory" ] && [ -z "$(ls -A "$directory")" ]; do
        rmdir "$directory"
        directory=$(dirname "$directory")  # Move up to the parent directory
    done
}

while IFS= read -r file; do
    original=$(echo $file | sed 's/\.*sync-conflict-[0-9]*-[0-9]*-[A-Z0-9]*//')
    if [[ -f "$original" ]]; then
        hash1=$(sha256sum "$file" | awk '{ print $1 }')
        hash2=$(sha256sum "$original" | awk '{ print $1 }')
        if [[ "$hash1" == "$hash2" ]]; then
            rm "$file"
        else
            echo "$file is different from conflicting copy."
            if [[ "$1" == "-f" ]]; then
                remove_file "$file"
            fi
        fi
    else
        echo "Warning: Found conflict file without original file ($file, expected $original)"
        if [[ "$1" == "-f" ]]; then
            remove_file "$file"
        fi
    fi
done <<< "$files"
exit 0
