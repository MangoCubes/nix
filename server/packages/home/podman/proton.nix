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

  imports = [ (inputs.secrets.hm.proton { inherit name; }) ];
  services.podman.containers."proton-${name}" = (
    (import ../../../../lib/podman.nix) {
      domain = null;
      network = [ "proxy" ];
      image = "qmcgaw/gluetun";
      name = "proton";
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
  );
}
