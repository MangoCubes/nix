{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.secrets.hm.ca
  ];
  custom.podman.containers.ca = {
    dependsOn = [ "traefik" ];
    image = "smallstep/step-ca";
    needRoot = true;
    volumes = [

      "${config.home.homeDirectory}/.config/sops-nix/secrets/caPassword:/home/step/secrets/password"
      "${config.home.homeDirectory}/.config/sops-nix/secrets/provisionerPassword:/home/step/secrets/provisioner_password"
      "${config.home.homeDirectory}/.config/sops-nix/secrets/intermediateCaKey:/home/step/secrets/intermediate_ca_key"

      "${config.home.homeDirectory}/.config/sops-nix/secrets/rootCaCert:/home/step/certs/root_ca.crt"
      "${config.home.homeDirectory}/.config/sops-nix/secrets/intermediateCaCrt:/home/step/certs/intermediate_ca.crt"

      "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt"

      "${./ca/ca.json}:/home/step/config/ca.json"

      "ca:/home/step/db"
    ];
    domain = [
      {
        url = "ca.int";
        port = 9000;
        extraServiceConfig.loadbalancer.server.scheme = "https";
      }
    ];
    environment = {
      "DOCKER_STEPCA_INIT_NAME" = "Intranet";
      "DOCKER_STEPCA_INIT_DNS_NAMES" = "localhost,ca.int,ca";
    };
  };
}
