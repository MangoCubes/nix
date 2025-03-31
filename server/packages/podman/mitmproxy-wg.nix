{ username, ... }:
{
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ];
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
              url = "mitmweb.local";
              type = 2;
              port = 8081;
            }
          ];
          ports = [ "51820:51820/udp" ];
          exec = "mitmweb --web-host 0.0.0.0 --set confdir=/etc/mitm --set 'web_password=\\$argon2i\\$v=19\\$m=4096,t=3,p=1\\$c2FsdEl0V2l0aFNhbHQ\\$jJHYL8FmjFuaY6nOHa5sCJT6qlk2OPWCg/feeJ3rWk0' --set mode=wireguard";
          volumes = [
            "${config.home.homeDirectory}/Sync/Secrets/mitm:/etc/mitm"
          ];
        }
      );
    };
}
