set -e
multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"

args=()

if [ "$save" = "1" ]; then
  args+=(--chooser-file="$out")
elif [ "$directory" = "1" ]; then
  args+=(--chooser-dir="$out")
else
  args+=(--chooser-file="$out")
fi

if [ -n "$path" ] && [ -e "$path" ]; then
  args+=("$path")
fi

exec @terminal@ --title=file_chooser -e yazi "${args[@]}"
