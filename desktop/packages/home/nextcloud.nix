{ unstable, ... }:
{
  # services.nextcloud-client.enable = true;
  # Nextcloud client will be started manually by niri
  # systemd.user.services.nextcloud-client.Install.WantedBy = lib.mkForce [ ];
  home.packages = [ unstable.nextcloud-client ];
}
