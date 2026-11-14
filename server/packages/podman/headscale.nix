{
  username,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.headscale;
  settings = (pkgs.formats.yaml { }).generate "config.yaml" {
    server_url = "https://${cfg.url}";
    listen_addr = "0.0.0.0:8080";
    metrics_listen_addr = "127.0.0.1:9090";
    noise.private_key_path = "/var/lib/headscale/noise_private.key";
    prefixes.v4 = "100.64.0.0/10";
    database = {
      type = "sqlite";
      sqlite.path = "/var/lib/headscale/db.sqlite";
    };
    dns = {
      magic_dns = true;
      base_domain = cfg.domain;
      override_local_dns = true;
      nameservers.global = [ "107.175.189.176" ];
    };
    derp = {
      server = {
        enabled = true;
        region_id = 999;
        region_code = "headscale";
        region_name = "Headscale Embedded DERP";
        stun_listen_addr = "0.0.0.0:3478";
        private_key_path = "/var/lib/headscale/derp_server_private.key";
      };
      urls = [ ];
    };
  };
in
{
  options.custom.headscale = {
    url = lib.mkOption {
      type = lib.types.str;
      default = "vpn.skew.ch";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = "local";
    };
  };

  config = {
    networking.firewall = {
      enable = true;
      allowedUDPPorts = [ 3478 ];
    };

    home-manager.users."${username}" = {
      custom.podman.containers.headscale = {
        image = "headscale/headscale:latest";
        exec = "serve";
        ports = [ "3478:3478/udp" ];
        mounts = [
          {
            inside = "/var/lib/headscale";
            outside = "headscale";
          }
          {
            inside = "/etc/headscale/config.yaml";
            outside = "${settings}";
            readOnly = true;
          }
        ];
        domain = [
          {
            url = cfg.url;
            port = 8080;
          }
        ];
      };
    };
  };
}
