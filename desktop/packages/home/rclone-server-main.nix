{
  pkgs,
  lib,
  ...
}:
let
  conf = pkgs.writeText "server-main.conf" ''
    [server-main]
    type = sftp
    host = server-main
    key_use_agent = true
  '';
in
{
  systemd.user.services.rclone-server-main = {
    Unit = {
      Description = "Mount server-main automatically";
    };
    Service = {
      Type = "notify";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/server-main";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=${conf} --vfs-cache-mode writes mount \"server-main:/home/main\" %h/Mounts/server-main";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      ExecStop = "/bin/fusermount -u %h/Mounts/server-main";
    };
    Install.WantedBy = lib.mkForce [ "default.target" ];
  };
}
