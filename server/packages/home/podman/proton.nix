{
  name,
}:
{
  config,
  inputs,
  ...
}:
{

  imports = [
    (inputs.secrets.server-main.home.gluetun { inherit name; })
    ((import ../../../../lib/podman.nix) ({
      dependsOn = [ "traefik" ];
      domain = null;
      network = [ "proxy" ];
      image = "qmcgaw/gluetun:latest";
      name = "proton-${name}";
      addCapabilities = [
        "NET_ADMIN"
        "NET_RAW"
      ];
      devices = [ "/dev/net/tun:/dev/net/tun" ];
      # entrypoint = ''
      #   # export Country=$(/gluetun-entrypoint format-servers -protonvpn -format json | grep country | uniq | shuf | head -n 1 | sed -nE 's/.+"country": "(.+)".+/\1/p');
      #   export Country="Netherlands";
      #   /gluetun-entrypoint
      # '';
      environmentFile = [ "${config.home.homeDirectory}/.config/sops-nix/secrets/gluetun/${name}" ];
    }))
  ];
}
