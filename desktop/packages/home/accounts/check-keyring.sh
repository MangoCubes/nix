locked=$(@busctl@ --user get-property org.freedesktop.secrets /org/freedesktop/secrets/aliases/default org.freedesktop.Secret.Collection Locked) || exit 1

[ "$locked" = "b false" ]
