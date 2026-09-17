{
  pkgs,
  lib,
  inputs,
  config,
  osConfig,
  ...
}:
let
  cfg = config.custom.rclone;
  deviceType = osConfig.custom.device.type or config.custom.device.type;
  flags = if deviceType == "server" then "--allow-other" else "";
in
{
  options.custom.rclone = {
    mounts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    sftp = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = {
    sops.secrets = lib.mkMerge (map (name: (inputs.secrets.hm."${name}").sops.secrets) cfg.mounts);

    systemd.user.services = lib.mkMerge (
      (map (name: {
        "rclone-${name}" = {
          Unit.Description = "Mount ${name} drive automatically";
          Service = {
            Type = "notify";
            ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/${name}";
            ExecStart = ''${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/${name} --vfs-cache-mode full mount "${name}:" %h/Mounts/${name} ${flags} -vv'';
            Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
            ExecStop = "/bin/fusermount -u %h/Mounts/${name}";
          };
          Install.WantedBy = if deviceType == "server" then [ "default.target" ] else [ ];
        };
      }) cfg.mounts)
      ++ (map (
        server:
        let
          conf = pkgs.writeText "${server}.conf" ''
            [${server}]
            type = sftp
            host = ${server}
            key_use_agent = true
          '';
        in
        {
          "rclone-${server}" = {
            Unit.Description = "Mount ${server}";
            Service = {
              Type = "notify";
              ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/${server}";
              ExecStart = "${pkgs.rclone}/bin/rclone --config=${conf} --vfs-cache-mode full mount \"${server}:/home/main\" %h/Mounts/${server} -vv";
              Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
              ExecStop = "/bin/fusermount -u %h/Mounts/${server}";
            };
          };
        }
      ) cfg.sftp)
    );
  };
}
