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
  imports = [ inputs.secrets.hm."2tb" ];
  systemd.user.services = {
    rclone-2tb = {
      Unit = {
        Description = "Mount 2TB server drive automatically";
      };
      Service = {
        Type = "notify";
        ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/2TB";
        # Needs --allow-other because of Ampache server
        ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/2tb --vfs-cache-mode full mount \"2tbenc:\" %h/Mounts/2TB ${flags}";
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        ExecStop = "/bin/fusermount -u %h/Mounts/2TB";
      };
      Install.WantedBy = lib.mkForce [ "default.target" ];
    };
  };
}
