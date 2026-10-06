col=$(@busctl@ --user call org.freedesktop.secrets /org/freedesktop/secrets org.freedesktop.Secret.Service ReadAlias s "default" | awk '{print $2}' | tr -d '"');
# False means the database is unlocked
@busctl@ --user get-property org.freedesktop.secrets "$col" org.freedesktop.Secret.Collection Locked | grep -q "false" && exit 0 || exit 1;

