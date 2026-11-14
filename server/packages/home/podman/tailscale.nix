{ osConfig, ... }:
{
  custom.podman.containers.tailscale = {
    vpn = "exit";
    image = "tailscale/tailscale:stable";
    environment = {
      TS_HOSTNAME = "exit";
      TS_EXTRA_ARGS = "--login-server=https://${osConfig.custom.headscale.url} --advertise-exit-node";
      TS_AUTH_ONCE = "true";
      TS_STATE_DIR = "/var/lib/tailscale";
      TS_TAILSCALED_EXTRA_ARGS = "--no-logs-no-support";
    };
    volumes = [ "/var/lib/tailscale" ];
  };
}
