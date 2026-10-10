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

# Install bootloader
# Without it, computer will not be able to boot into newer builds on reboot, and make it look like the computer is resetting every reboot
bootloader=false

# Boot mode
# Use boot instead of switch
boot_mode=false

repo="$HOME/Sync/NixConfig"
flake="git+file://$repo"

if [[ $1 == *"b"* ]]; then
    boot_mode=true
fi

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
	boot_mode=true
    reboot=true
fi

if [[ $1 == *"B"* ]]; then
    bootloader=true
fi

# Print the results
echo "Rebuild secrets: $rebuild_secrets"
echo "Presentation mode: $presentation"
echo "Update unstable: $update_unstable"
echo "Update all: $update_all"
echo "Reboot after successful rebuild: $reboot"
echo "Install bootloader: $bootloader"
echo "Boot mode: $boot_mode"

if [ "$rebuild_secrets" = true ]; then
	sudo nix flake update secrets --flake "$flake"
fi

device_name=$(hostname)

presentation_args=()
if [ "$presentation" = true ]; then
	presentation_args=(--specialisation presentation)
fi

if [ "$update_unstable" = true ]; then
	sudo nix flake update --flake "$flake" unstablePkg
fi

if [ "$update_all" = true ]; then
	sudo nix flake update --flake "$flake"
fi

action="switch"
if [ "$boot_mode" = true ]; then
	action="boot"
fi

if [ "$bootloader" = true ]; then
	sudo nixos-rebuild --flake "$flake#$device_name" "$action" "${presentation_args[@]}" --install-bootloader --no-reexec
else 
	sudo nixos-rebuild --flake "$flake#$device_name" "$action" "${presentation_args[@]}" --no-reexec
fi

if [ $? -eq 0 ] && [ "$reboot" = true ]; then
    reboot
fi
