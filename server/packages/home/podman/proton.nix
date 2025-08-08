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
    ((import ../../../../lib/podman.nix) (
      {
        dependsOn = [ "traefik" ];
        domain = null;
        network = [ "proxy" ];
        image = "qmcgaw/gluetun";
        name = "proton-${name}";
        addCapabilities = [ "NET_ADMIN" ];
        devices = [ "/dev/net/tun:/dev/net/tun" ];
        environmentFile = [ ''${config.home.homeDirectory}/.config/sops-nix/secrets/proton-${name}'' ];
      }
      // (
        if useInternalDns then
          {
            environment = {
              "DNS_KEEP_NAMESERVER" = "on";
            };
          }
        else
          { }
      )
    ))
  ];
}
