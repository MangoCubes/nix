{ config, username, ... }:

let
  homeDir = config.users.users.${username}.home;
in
{
  systemd.mounts = [
    {
      what = "/dev/disk/by-uuid/1a9e70cd-ddf3-497c-9a92-48406b0b55ba";
      type = "ext4";
      where = "${homeDir}/Mounts/Work";
      enable = true;
      wantedBy = [ "multi-user.target" ];
      options = "auto,nofail";
    }
  ];
}
