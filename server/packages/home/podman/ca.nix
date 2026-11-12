{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.secrets.server.packages.home.podman.ca ];
  custom.podman.containers.ca = {
    image = "smallstep/step-ca";
    needRoot = true;
    mounts = [
      {
        inside = "/home/step/secrets/password";
        outside = config.sops.secrets.caPassword.path;
      }
      {
        inside = "/home/step/secrets/provisioner_password";
        outside = config.sops.secrets.provisionerPassword.path;
      }
      {
        inside = "/home/step/secrets/intermediate_ca_key";
        outside = config.sops.secrets.intermediateCaKey.path;
      }

      {
        inside = "/home/step/certs/root_ca.crt";
        outside = config.sops.secrets.rootCaCert.path;
      }
      {
        inside = "/home/step/certs/intermediate_ca.crt";
        outside = config.sops.secrets.intermediateCaCrt.path;
      }

      {
        inside = "/home/step/config/ca.json";
        outside = "${./ca/ca.json}";
      }
    ];
    volumes = [ "/home/step/db" ];
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
