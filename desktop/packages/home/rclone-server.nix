server:
{
  pkgs,
  lib,
  ...
}:
let
  conf = pkgs.writeText "${server}.conf" ''
    [${server}]
    type = sftp
    host = ${server}
    key_use_agent = true
  '';
in
{
  systemd.user.services."rclone-${server}" = {
    Unit = {
      Description = "Mount ${server}";
    };
    Service = {
      Type = "notify";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/${server}";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=${conf} --vfs-cache-mode full mount \"${server}:/home/main\" %h/Mounts/${server}";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      ExecStop = "/bin/fusermount -u %h/Mounts/${server}";
    };
    # Install.WantedBy = lib.mkForce [ "default.target" ];
  };
}
