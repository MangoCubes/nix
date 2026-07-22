{
  pkgs,
  lib,
  inputs,
  device,
  ...
}:
let
  flags = if device.type == "server" then "--allow-other" else "";
in
{
  imports = [ inputs.secrets.hm.drive ];
  systemd.user.services = {
    rclone-drive = {
      Unit = {
        Description = "Mount Google Drive automatically";
      };
      Service = {
        Type = "notify";
        ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/Drive";
        # Needs --allow-other because of Ampache server
        ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/drive --vfs-cache-mode full mount \"driveenc:\" %h/Mounts/Drive ${flags}";
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        ExecStop = "/bin/fusermount -u %h/Mounts/Drive";
      };
      Install.WantedBy = lib.mkForce [ "default.target" ];
    };
  };
}
