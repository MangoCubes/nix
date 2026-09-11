{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.secrets.hm.other
  ];
  custom.podman.containers = [
    {
      dependsOn = null;
      image = "postgres:17";
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
        "${config.home.homeDirectory}/.config/sops-nix/secrets/postgresql"
      ];
    }
  ];
}
