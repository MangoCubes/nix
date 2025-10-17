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
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.secrets.server-main.home.mitm
        ((import ../../../lib/podman.nix) {
          dependsOn = [ "traefik" ];
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
          entrypoint = "mitmweb --web-host 0.0.0.0 --set confdir=/etc/mitm --set 'web_password=$argon2i$v=19$m=4096,t=3,p=1$c2FsdEl0V2l0aFNhbHQ$jJHYL8FmjFuaY6nOHa5sCJT6qlk2OPWCg/feeJ3rWk0' --set mode=wireguard";
          volumes =
            let
              files = inputs.secrets.res;
            in
            [
              "${files}/keys/mitm/mitm.pem:/etc/mitm/mitmproxy-ca-cert.cer"
              "${files}/keys/mitm/mitm.p12:/etc/mitm/mitmproxy-ca-cert.p12"
              "${files}/keys/mitm/mitm.pem:/etc/mitm/mitmproxy-ca-cert.pem"
              "${config.home.homeDirectory}/.config/sops-nix/secrets/mitm/mitmproxy-ca.p12:/etc/mitm/mitmproxy-ca.p12"
              "${config.home.homeDirectory}/.config/sops-nix/secrets/mitm/mitmproxy-ca.pem:/etc/mitm/mitmproxy-ca.pem"
              "${config.home.homeDirectory}/.config/sops-nix/secrets/mitm/mitmproxy-dhparam.pem:/etc/mitm/mitmproxy-dhparam.pem"
              "${config.home.homeDirectory}/.config/sops-nix/secrets/mitm/wireguard.conf:/etc/mitm/wireguard.conf"
            ];
        })
      ];
    };
}
