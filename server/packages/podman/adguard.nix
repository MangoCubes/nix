{
  username,
  inputs,
  lib,
  ...
}:
let
  records = {
    server-home = [
      "yt.int"
      "slsk.int"
      "android.int"
      "artex.int"
    ];
    server-main = [
      "music.int"
      "mitm.int"
      "git.int"
    ];
    server-network = [ "ca.int" ];
  };
  rewrites =
    lib.concatMap (device: [
      {
        domain = "*.${device}.local";
        answer = "${device}.local";
      }
    ]) (builtins.attrNames inputs.self.nixosConfigurations)
    ++ lib.concatLists (
      lib.mapAttrsToList (
        device:
        builtins.map (name: {
          domain = name;
          answer = "${device}.local";
        })
      ) records
    );
in
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = lib.mkForce 53;
    "net.ipv4.ip_nonlocal_bind" = 1;
  };
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 53 ];
  };
  services.tailscale.extraSetFlags = [ "--accept-dns=false" ];
  home-manager.users."${username}" =
    {
      config,
      osConfig,
      pkgs,
      ...
    }:
    let
      settings = (pkgs.formats.yaml { }).generate "AdGuardHome.yaml" {
        inherit (pkgs.adguardhome) schema_version;
        http.address = "0.0.0.0:80";
        users = [
          {
            name = "admin";
            password = "$2a$10$WbyRnNq0PJHD2sunY1pBeObSNTGCP7Ng0BQcpBWzhQxS2AJxTbI6e";
          }
        ];
        dns = {
          port = 53;
          upstream_dns = [
            "https://dns10.quad9.net/dns-query"
            "[/${osConfig.custom.headscale.domain}/]100.100.100.100"
          ];
        };
        filtering = {
          rewrites_enabled = true;
          rewrites = builtins.map (rewrite: rewrite // { enabled = true; }) rewrites;
        };
      };
    in
    {
      custom.podman.containers.adguard = {
        # The tag follows nixpkgs so that schema_version matches the image
        image = "adguard/adguardhome:v${pkgs.adguardhome.version}";
        needRoot = true;
        mounts = [
          {
            inside = "/my/AdGuardHome.yaml";
            outside = "${settings}";
            readOnly = true;
          }
        ];
        entrypoint = ''
          cp /my/AdGuardHome.yaml /opt/adguardhome/conf/AdGuardHome.yaml
          exec /opt/adguardhome/AdGuardHome --no-check-update -c /opt/adguardhome/conf/AdGuardHome.yaml -w /opt/adguardhome/work'';
        volumes = [ "/opt/adguardhome/work" ];
        ip4 = config.custom.podman.dnsProvider;
        ports = [
          "100.64.0.1:53:53/udp"
          "107.175.189.176:53:53/udp"
        ];

        domain = [
          {
            url = "dns.skew.ch";
            port = 80;
          }
        ];
      };
    };
}
