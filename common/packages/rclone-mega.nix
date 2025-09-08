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
      imports = [ inputs.secrets.hm.mega ];
      systemd.user.services = {
        rclone-mega = {
          Unit = {
            Description = "Mount media drive automatically";
          };
          Service = {
            Type = "notify";
            ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/media";
            ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/mega --vfs-cache-mode full mount \"encmega:\" %h/Mounts/media --allow-other";
            Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
            ExecStop = "/bin/fusermount -u %h/Mounts/media";
          };
          Install.WantedBy = lib.mkForce [ "default.target" ];
        };
      };
    };
}
