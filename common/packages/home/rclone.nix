name:
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
  imports = [ inputs.secrets.hm."${name}" ];
  systemd.user.services = {
    "rclone-${name}" = {
      Unit = {
        Description = "Mount ${name} drive automatically";
      };
      Service = {
        Type = "notify";
        ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/${name}";
        # Needs --allow-other because of music player
        ExecStart = ''${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/${name} --vfs-cache-mode full mount "${name}:" %h/Mounts/${name} ${flags}'';
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        ExecStop = "/bin/fusermount -u %h/Mounts/${name}";
      };
      Install.WantedBy = lib.mkForce (if device.type == "server" then [ "default.target" ] else [ ]);
    };
  };
}
