{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.secrets.hm.other
    ((import ../../../../lib/podman.nix) {
      dependsOn = null;
      image = "postgres:17";
      network = "container:proton-inv";
      name = "postgresql";
      activation = ''
        mkdir -p /home/main/.podman/postgres/scripts
        mkdir -p /home/main/.podman/postgres/data
      '';
      volumes = [
        "${config.home.homeDirectory}/.podman/postgres/data:/var/lib/postgresql/data"
        "${config.home.homeDirectory}/.podman/postgres/scripts:/var/lib/postgresql/scripts"
      ];
      environmentFile = [
        ''${config.home.homeDirectory}/.config/sops-nix/secrets/postgresql''
      ];
    })
  ];
}
