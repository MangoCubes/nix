{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.secrets.hm.ca ];
  services.podman.containers.ca = (
    (import ../../../../lib/podman.nix) {
      image = "smallstep/step-ca";
      name = "ca";
      needRoot = true;
      volumes = [

        "${config.home.homeDirectory}/.config/sops-nix/secrets/caPassword:/home/step/secrets/password"
        "${config.home.homeDirectory}/.config/sops-nix/secrets/provisionerPassword:/home/step/secrets/provisioner_password"
        "${config.home.homeDirectory}/.config/sops-nix/secrets/intermediateCaKey:/home/step/secrets/intermediate_ca_key"

        "${config.home.homeDirectory}/.config/sops-nix/secrets/rootCaCert:/home/step/certs/root_ca.crt"
        "${config.home.homeDirectory}/.config/sops-nix/secrets/intermediateCaCrt:/home/step/certs/intermediate_ca.crt"

        "${./ca/ca.json}:/home/step/config/ca.json"

        "ca:/home/step/db"
      ];
      domain = [
        {
          routerName = "ca";
          type = 2;
          url = "ca.local";
          port = 9000;
        }
      ];
      environment = {
        "DOCKER_STEPCA_INIT_NAME" = "Intranet";
        "DOCKER_STEPCA_INIT_DNS_NAMES" = "localhost,ca";
      };
      labels = {
        "traefik.http.services.s-ca.loadbalancer.server.scheme" = "https";
        # "traefik.http.services.s-ca.loadbalancer.serversTransport" = "homeTransport";
      };
    }
  );
}
