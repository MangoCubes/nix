{
  pkgs,
  lib,
  ...
}:
let
  conf = pkgs.writeText "server-media.conf" ''
    [server-media]
    type = sftp
    host = server-media
    key_use_agent = true
  '';
in
{
  systemd.user.services.rclone-server-media = {
    Unit = {
      Description = "Mount server-media automatically";
    };
    Service = {
      Type = "notify";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/server-media";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=${conf} --vfs-cache-mode full mount \"server-media:\" %h/Mounts/server-media";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      ExecStop = "/bin/fusermount -u %h/Mounts/server-media";
    };
    Install.WantedBy = lib.mkForce [ "default.target" ];
  };
}
