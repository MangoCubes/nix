const code = (await fetch("https://r.genit.al")).status;
if (!(code >= 200 && code < 300)) {
	// Error has occurred, need to restart
	console.log("Service has been ratelimited, restarting service.");
	await $`__pkgs.systemd__/bin/systemctl --user stop podman-redlib-vpn`;
	console.log("Restarting VPN...");
	await $`__pkgs.systemd__/bin/systemctl --user restart podman-proton-redlib`;
	console.log("Starting Redlib...");
	await $`__pkgs.systemd__/bin/systemctl --user start podman-redlib-vpn`;
	console.log("Service restarted!");
} else {
	console.log("Service is running normally.");
}

