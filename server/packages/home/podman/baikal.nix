{
  config,
  ...
}:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = null;
      image = "ckulka/baikal:nginx";
      name = "baikal";
      domain = [
        {
          routerName = "baikal";
          url = "cal.skew.ch";
          type = 1;
          port = 80;
        }
      ];
      volumes = [
        "${config.home.homeDirectory}/.podman/baikal/data:/var/www/baikal/Specific"
        "${config.home.homeDirectory}/.podman/baikal/config:/var/www/baikal/config"
      ];
    })
  ];
}
