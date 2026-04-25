{
  config,
  osConfig,
  pkgs,
  ...
}:
[
  {
    key = "d";
    desc = "Directories";
    submenu = [
      {
        key = "d";
        desc = "Downloads";
        cmd = "dragevac --load-dir ~/Downloads/";
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
