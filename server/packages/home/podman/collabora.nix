{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "cloud" ];
      image = "collabora/code:latest";
      name = "collabora";
      environment = {
        "domain" = "cloud.skew.ch";
        "VIRTUAL_PROTO" = "http";
        "VIRTUAL_PORT" = "9980";
        "VIRTUAL_HOST" = "office.skew.ch";
        # Remember to put quotes around the parameters
        # Notice how I put '' around "s
        "extra_params" = ''"--o:ssl.enable=false --o:ssl.termination=true"'';
      };
      domain = [
        {
          routerName = "collabora";
          url = "office.skew.ch";
          type = 1;
          port = 9980;
        }
      ];
    })
  ];
}
