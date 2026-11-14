# Register each device once with `sudo tailscale up --login-server https://vpn.skew.ch`
# Then approve it on server-network with `podman exec headscale headscale nodes register --user main --key <key>`
{
  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = [ "1.1.1.1#cloudflare-dns.com" ];
  };
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    disableUpstreamLogging = true;
  };
}
