{
  name,
  useInternalDns ? false,
}:
{
  config,
  inputs,
  ...
}:
{

  imports = [
    (inputs.secrets.hm.proton { inherit name; })
    ((import ../../../../lib/podman.nix) ({
      dependsOn = [ "traefik" ];
      domain = null;
      network = [ "proxy" ];
      image = "qmcgaw/gluetun";
      name = "proton-${name}";
      addCapabilities = [ "NET_ADMIN" ];
      devices = [ "/dev/net/tun:/dev/net/tun" ];
      entrypoint = ''
        export Country=$(/gluetun-entrypoint format-servers -protonvpn -format json | grep country | shuf | head -n 1 | sed -nE 's/.+"country": "(.+)".+/\1/p');
        /gluetun-entrypoint
      '';
      environment = (
        if useInternalDns then
          {
            "DNS_KEEP_NAMESERVER" = "on";
          }
        else
          { }
      );
      environmentFile = [ ''${config.home.homeDirectory}/.config/sops-nix/secrets/proton-${name}'' ];
    }))
  ];
}
