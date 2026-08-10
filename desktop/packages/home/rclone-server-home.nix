{
  pkgs,
  lib,
  ...
}:
let
  conf = pkgs.writeText "server-home.conf" ''
    [server-home]
    type = sftp
    host = server-home
    key_use_agent = true
  '';
in
{
  systemd.user.services.rclone-server-home = {
    Unit = {
      Description = "Mount server-home automatically";
    };
    Service = {
      Type = "notify";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/server-home";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=${conf} --vfs-cache-mode full mount \"server-home:/home/main\" %h/Mounts/server-home";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      ExecStop = "/bin/fusermount -u %h/Mounts/server-home";
    };
    Install.WantedBy = lib.mkForce [ "default.target" ];
  };
}
