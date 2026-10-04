{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.secrets.hm.ca ];
  custom.podman.containers.ca = {
    dependsOn = [ "traefik" ];
    image = "smallstep/step-ca";
    needRoot = true;
    volumes = [

      "${config.sops.secrets.caPassword.path}:/home/step/secrets/password"
      "${config.sops.secrets.provisionerPassword.path}:/home/step/secrets/provisioner_password"
      "${config.sops.secrets.intermediateCaKey.path}:/home/step/secrets/intermediate_ca_key"

      "${config.sops.secrets.rootCaCert.path}:/home/step/certs/root_ca.crt"
      "${config.sops.secrets.intermediateCaCrt.path}:/home/step/certs/intermediate_ca.crt"

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
