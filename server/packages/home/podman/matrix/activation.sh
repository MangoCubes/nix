DIR="$HOME/.podman/matrix"
if [ ! -d "$DIR" ]; then
  @rootlesskit@ mkdir -p "$DIR/uploads"
  @rootlesskit@ mkdir -p "$DIR/media"
fi
@rootlesskit@ rm -f "$HOME/.podman/matrix/homeserver.yaml"
@rootlesskit@ cp "$HOME/.config/sops-nix/secrets/matrix/homeserver.yaml" "$HOME/.podman/matrix/homeserver.yaml"
@rootlesskit@ rm -f "$HOME/.podman/matrix/skew.ch.signing.key"
@rootlesskit@ cp "$HOME/.config/sops-nix/secrets/matrix/skew.ch.signing.key" "$HOME/.podman/matrix/skew.ch.signing.key"
@rootlesskit@ rm -f "$HOME/.podman/matrix/skew.ch.log.config"
@rootlesskit@ cp "$HOME/.config/sops-nix/secrets/matrix/skew.ch.log.config" "$HOME/.podman/matrix/skew.ch.log.config"

@rootlesskit@ rm -f "$HOME/.podman/matrix/mas.yaml"
@rootlesskit@ cp "$HOME/.config/sops-nix/secrets/matrix/mas.yaml" "$HOME/.podman/matrix/mas.yaml"
@rootlesskit@ rm -f "$HOME/.podman/matrix/hookshot.yaml"
@rootlesskit@ cp "$HOME/.config/sops-nix/secrets/matrix/hookshot.yaml" "$HOME/.podman/matrix/hookshot.yaml"
@rootlesskit@ rm -f "$HOME/.podman/matrix-hookshot/registration.yml"
@rootlesskit@ cp "$HOME/.config/sops-nix/secrets/matrix/hookshot.yaml" "$HOME/.podman/matrix-hookshot/registration.yml"
@rootlesskit@ rm -f "$HOME/.podman/matrix-hookshot/config.yml"
@rootlesskit@ cp "@hookshotConfig@" "$HOME/.podman/matrix-hookshot/config.yml"

@rootlesskit@ chown 991:991 -R "$HOME/.podman/matrix"
@rootlesskit@ chown 65532:65532 "$HOME/.podman/matrix/mas.yaml"
