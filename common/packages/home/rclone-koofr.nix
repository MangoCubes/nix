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
  imports = [ inputs.secrets.hm.koofr ];
  systemd.user.services = {
    rclone-koofr = {
      Unit = {
        Description = "Mount Koofr drive automatically";
      };
      Service = {
        Type = "notify";
        ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/Koofr";
        # Needs --allow-other because of Ampache server
        ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/koofr --vfs-cache-mode full mount \"enckoofr:\" %h/Mounts/Koofr ${flags}";
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        ExecStop = "/bin/fusermount -u %h/Mounts/Koofr";
      };
      Install.WantedBy = lib.mkForce [ "default.target" ];
    };
  };
}
