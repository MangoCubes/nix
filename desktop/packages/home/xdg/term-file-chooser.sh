set -e
multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"

args=(--chooser-file="$out")

if [ -n "$path" ] && [ -e "$path" ]; then
  args+=("$path")
fi

exec @terminal@ --title=file_chooser -e yazi "${args[@]}"
