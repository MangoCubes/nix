{ config, ... }:
{
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}

# Then run the following commands:
# tailscale up --login-server <headscale_url>
# Combined with docker-compose, run this command on the server:
# docker exec -it vpn headscale nodes register --user main --key <machine_key>

# To set a new exit node:
# Advertise as exit node on the node itself
# sudo tailscale set --advertise-exit-node=true
# Then go to Headscale server and also enable it as exit node
# docker exec -it vpn headscale routes list
# docker exec -it vpn headscale routes enable -r <route number>
