{ username, ... }:
{
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ];
  };
  home-manager.users."${username}" =
    {
      config,
      inputs,
      ...
    }:
    {
      imports = [ inputs.secrets.server-main.home.mitm ];
      custom.podman.containers.mitm = {
        image = "mitmproxy/mitmproxy";
        domain = [
          {
            url = "mitm.int";
            port = 8081;
          }
        ];
        ports = [ "51820:51820/udp" ];
        entrypoint = "mitmweb --web-host 0.0.0.0 --set confdir=/etc/mitm --set 'web_password=$argon2i$v=19$m=4096,t=3,p=1$c2FsdEl0V2l0aFNhbHQ$jJHYL8FmjFuaY6nOHa5sCJT6qlk2OPWCg/feeJ3rWk0' --set mode=wireguard";
        mounts =
          let
            files = inputs.secrets.res;
          in
          [
            {
              inside = "/etc/mitm/mitmproxy-ca-cert.cer";
              outside = "${files}/keys/mitm/mitm.pem";
            }
            {
              inside = "/etc/mitm/mitmproxy-ca-cert.p12";
              outside = "${files}/keys/mitm/mitm.p12";
            }
            {
              inside = "/etc/mitm/mitmproxy-ca-cert.pem";
              outside = "${files}/keys/mitm/mitm.pem";
            }
            {
              inside = "/etc/mitm/mitmproxy-ca.p12";
              outside = config.sops.secrets.mitm-mitmproxy-ca-p12.path;
            }
            {
              inside = "/etc/mitm/mitmproxy-ca.pem";
              outside = config.sops.secrets.mitm-mitmproxy-ca-pem.path;
            }
            {
              inside = "/etc/mitm/mitmproxy-dhparam.pem";
              outside = config.sops.secrets.mitm-mitmproxy-dhparam-pem.path;
            }
            {
              inside = "/etc/mitm/wireguard.conf";
              outside = config.sops.secrets.mitm-wireguard.path;
            }
          ];
      };
    };
}
