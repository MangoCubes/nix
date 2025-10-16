# Rebuild secrets flake
rebuild_secrets=false

# Remove Miku :(
presentation=false

# Update unstable and secrtes
update_unstable=false

# Update all
update_all=false

# Reboot after successful rebuild
reboot=false

if [[ $1 == *"s"* ]]; then
    rebuild_secrets=true
fi

if [[ $1 == *"p"* ]]; then
    presentation=true
fi

if [[ $1 == *"u"* ]]; then
    rebuild_secrets=true
    update_unstable=true
fi

if [[ $1 == *"a"* ]]; then
    rebuild_secrets=true
    update_all=true
fi

if [[ $1 == *"r"* ]]; then
    reboot=true
fi

# Print the results
echo "Rebuild secrets: $rebuild_secrets"
echo "Presentation mode: $presentation"
echo "Update unstable: $update_unstable"
echo "Update all: $update_all"
echo "Reboot after successful rebuild: $reboot"

if [ "$rebuild_secrets" = true ]; then
	sudo nix flake update secrets --flake $HOME/Sync/NixConfig
fi

if [ "$presentation" = true ]; then
    device_name="$(hostname)Presentation"
else
    device_name=$(hostname)
fi

if [ "$update_unstable" = true ]; then
	nix flake update --flake path://$HOME/Sync/NixConfig unstablePkg
fi

if [ "$update_all" = true ]; then
	nix flake update --flake path://$HOME/Sync/NixConfig
fi

sudo nixos-rebuild --flake path://$HOME/Sync/NixConfig#$device_name switch

if [ "$reboot" = true ]; then
	reboot
fi
