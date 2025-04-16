{ username, ... }:
{
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51822 ];
  };
  home-manager.users."${username}" =
    {
      config,
      ...
    }:
    {
      services.podman.containers.mitm = (
        (import ../../../lib/podman.nix) {

          hostname = "mitmproxy";
          image = "mitmproxy/mitmproxy";
          name = "mitm";
          domain = [
            {
              routerName = "mitm-web";
              url = "mitm.skew.ch";
              type = 1;
              port = 8081;
            }
          ];
          ports = [ "51822:51820/udp" ];
          exec = "mitmweb --web-host 0.0.0.0 --set confdir=/etc/mitm --set 'web_password=xxxxxxxx' --set mode=wireguard";
          volumes = [
            "${config.home.homeDirectory}/Sync/Secrets/mitm:/etc/mitm"
          ];
        }
      );
    };
}
