{ username, ... }:
{
  programs.fuse.userAllowOther = true;

  home-manager.users."${username}" =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    {
      imports = [ inputs.secrets.hm.school ];
      systemd.user.services = {
        rclone-school = {
          Unit = {
            Description = "Mount school drive automatically";
          };
          Service = {
            Type = "notify";
            ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/school";
            ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/school --vfs-cache-mode writes mount \"school:\" %h/Mounts/school --allow-other";
            Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
            ExecStop = "/bin/fusermount -u %h/Mounts/school";
          };
          Install.WantedBy = lib.mkForce [ "default.target" ];
        };
      };
    };
}
