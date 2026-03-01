{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.secrets.hm.koofr ];
  systemd.user.services = {
    rclone-koofr = {
      Unit = {
        Description = "Mount Koofr drive automatically";
      };
      Service = {
        Type = "notify";
        ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/Koofr";
        ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/koofr --vfs-cache-mode full mount \"enckoofr:\" %h/Mounts/Koofr --allow-other";
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        ExecStop = "/bin/fusermount -u %h/Mounts/Koofr";
      };
      Install.WantedBy = lib.mkForce [ "default.target" ];
    };
  };
}
