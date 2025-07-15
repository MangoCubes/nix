{
  pkgs,
  unstable,
  inputs,
  lib,
  ...
}:
{
  # services.nextcloud-client.enable = true;
  # Nextcloud client will be started manually by niri
  home.packages = [ unstable.nextcloud-client ];
  imports = [ inputs.secrets.hm.nextcloud ];
  systemd.user.services = {
    rclone-cloud = {
      Unit = {
        Description = "Mount Nextcloud drive automatically";
      };
      Service = {
        Type = "notify";
        ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/Cloud";
        ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/rclone-cloud --vfs-cache-mode writes mount \"cloud:\" %h/Mounts/Cloud --allow-other";
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        ExecStop = "/bin/fusermount -u %h/Mounts/Cloud";
      };
      Install.WantedBy = lib.mkForce [ "default.target" ];
    };
  };
}
