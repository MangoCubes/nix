{ inputs, ... }:
{
  custom.traefik = {
    enable = true;
    dynamic = inputs.secrets.server-home.traefik.dynamic;
    static = inputs.secrets.server-home.traefik.static;
  };
}
