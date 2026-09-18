{ name }:
{
  config,
  inputs,
  hostname,
  osConfig,
  ...
}:
{

  imports = [
    (inputs.secrets."${osConfig.networking.hostName}".home.gluetun { inherit name; })
  ];
  custom.podman.containers."proton-${name}" = {
    dependsOn = [ "traefik" ];
    domain = null;
    network = [ "proxy" ];
    image = "qmcgaw/gluetun:latest";
    addCapabilities = [
      "NET_ADMIN"
      "NET_RAW"
    ];
    devices = [ "/dev/net/tun:/dev/net/tun" ];
    entrypoint = ''
      export Country=$(/gluetun-entrypoint format-servers -protonvpn -format json | grep country | uniq | shuf | head -n 1 | sed -nE 's/.+"country": "(.+)".+/\1/p');
      /gluetun-entrypoint
    '';
    environmentFile = [ "${config.home.homeDirectory}/.config/sops-nix/secrets/gluetun/${name}" ];
  };
}
