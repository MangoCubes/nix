{ username, ... }:
{
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 3478 ];
  };

  home-manager.users."${username}" =

    {
      config,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.secrets.server-network.home.netbird
      ];
      custom.podman.containers = {
        netbird-server = {
          dependsOn = [ "traefik" ];
          image = "netbirdio/netbird-server:latest";
          ports = [ "3478:3478/udp" ];
          volumes = [
            "${config.home.homeDirectory}/.podman/netbird:/var/lib/netbird"
            "${config.home.homeDirectory}/.config/sops-nix/secrets/netbird/config.yaml:/etc/netbird/config.yaml"
          ];
          entrypoint = "/go/bin/netbird-server --config /etc/netbird/config.yaml";
          domain = [
            {
              rule = "Host(`vpn.skew.ch`) && (PathPrefix(`/signalexchange.SignalExchange/`) || PathPrefix(`/management.ManagementService/`))";
              certResolver = "letsencrypt";
              port = 80;
              extraRouterConfig.priority = "1000";
              extraServiceConfig.loadbalancer.server.scheme = "h2c";
            }
            {
              rule = "Host(`vpn.skew.ch`) && (PathPrefix(`/relay`) || PathPrefix(`/ws-proxy/`) || PathPrefix(`/api`) || PathPrefix(`/oauth2`))";
              certResolver = "letsencrypt";
              port = 80;
              extraRouterConfig.priority = "1000";
            }
          ];
        };
        netbird-dashboard = {
          dependsOn = [ "traefik" ];
          image = "netbirdio/dashboard:latest";
          environmentFile = [ "${config.home.homeDirectory}/.config/sops-nix/secrets/netbird/env.conf" ];
          domain = [
            {
              url = "vpn.skew.ch";
              port = 80;
            }
          ];
        };
      };
    };
}
