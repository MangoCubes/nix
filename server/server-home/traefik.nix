{ secrets, ... }:
{
  custom.traefik = {
    enable = true;
    dynamic = secrets.server-home.traefik.dynamic;
    static = secrets.server-home.traefik.static;
  };
}
