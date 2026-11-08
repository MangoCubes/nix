{ config, ... }:
[
  {
    key = "d";
    desc = "Directories";
    submenu = [
      {
        key = "d";
        desc = "Downloads";
        cmd = "dragevac --load-dir ${config.custom.bookmarks.Downloads.path}";
      }
      {
        key = "k";
        desc = "Keys";
        cmd = "dragevac --load-dir ${config.custom.bookmarks.Secrets.path}";
      }
    ];
  }
  {
    key = "t";
    desc = "Temporary";
    cmd = "dragevac temporary";
  }
  {
    key = "p";
    desc = "Persistent";
    cmd = "dragevac persistent";
  }
  {
    key = "e";
    desc = "Ephemeral";
    cmd = "dragevac no-save";
  }
]
