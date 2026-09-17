{ ... }:
{
  custom.traefik = {
    enable = true;
    static.certificatesResolvers.letsencrypt.acme = {
      email = "postmaster@skew.ch";
      storage = "/etc/traefik/ssl/letsencrypt.json";
      httpChallenge.entryPoint = "web";
    };
  };
}
