{
  url,
  port,
  target,
}:
let
  name = "anubis-${target}";
  # Random number, hopefully no services use this
  anubisPort = 57261;
in
{
  config,
  ...
}:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "ghcr.io/techarohq/anubis:latest";
      name = name;
      network = [ "container:proton-redlib" ];
      volumes = [
        "${./anubis/botPolicy.json}:/data/cfg/botPolicy.json"
      ];
      # dns = "10.89.0.1";
      domain = [
        {
          routerName = name;
          type = 1;
          port = anubisPort;
          inherit url;
        }
      ];
      environment = {
        "BIND" = ":${builtins.toString anubisPort}";
        "DIFFICULTY" = "4";
        # "METRICS_BIND" = ":9090";
        "SERVE_ROBOTS_TXT" = "true";
        "TARGET" = "http://${target}:${builtins.toString port}";
        "POLICY_FNAME" = "/data/cfg/botPolicy.json";
        "OG_PASSTHROUGH" = "true";
        "OG_EXPIRY_TIME" = "24h";
      };
    })
  ];
}
