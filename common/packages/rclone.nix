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
      imports = [ inputs.secrets.hm.rclone ];
      systemd.user.services = {
        media = {
          Unit = {
            Description = "Mount media drive automatically";
          };
          Service = {
            Type = "notify";
            ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mount/media";
            ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/rclone --vfs-cache-mode writes mount \"encmega:\" %h/Mount/media --allow-other";
            Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
            ExecStop = "/bin/fusermount -u %h/Mount/media";
          };
          Install.WantedBy = lib.mkForce [ "default.target" ];
        };
      };
    };
}
