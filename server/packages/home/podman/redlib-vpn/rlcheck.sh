status=$(@timeout@ 5 @curl@ -o /dev/null -s -w "%{http_code}" https://r.genit.al)
echo "Status: $status"
if [[ $status != 2* ]]; then
	echo "Ratelimited!"
    echo "Stopping Redlib..."
    @systemctl@ --user stop podman-anubis-redlib-vpn
    @systemctl@ --user stop podman-redlib-vpn
    echo "Restarting VPN..."
	@systemctl@ --user restart podman-proton-redlib
	echo "Starting Redlib..."
	@systemctl@ --user start podman-redlib-vpn
    @systemctl@ --user start podman-anubis-redlib-vpn
else
  echo "Server is working!"
fi
echo "Done!"
