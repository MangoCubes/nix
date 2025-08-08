{
  username,
  pkgs,
  inputs,
  ...
}:
# podman exec vpn headscale nodes register --user main --key mkey:<KEY>
let
  policy = ./headscale/policy.json;
  config = (
    (pkgs.formats.yaml { }).generate "config.yml" ((import ./headscale/config.nix) { inherit inputs; })
  );
in
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
  };
  home-manager.users."${username}" = {
    # List all targets using systemctl list-units --type target
    imports = [
      ((import ../../../lib/podman.nix) {
        dependsOn = null;
        image = "headscale/headscale";
        exec = "serve";
        name = "headscale";
        volumes = [
          "${config}:/etc/headscale/config.yaml"
          "${policy}:/etc/headscale/policy.json"
          "vpn:/var/lib/headscale"
        ];
        domain = [
          {
            routerName = "headscale";
            type = 1;
            url = "newvpn.skew.ch";
            port = 8080;
          }
        ];
      })
    ];
  };
}
