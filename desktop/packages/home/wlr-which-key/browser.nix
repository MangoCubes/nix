{ osConfig, lib, ... }:
[
  {
    key = "s";
    desc = "School";
    cmd = "profilebrowser School";
  }
  {
    key = "i";
    desc = "Intranet";
    cmd = "profilebrowser Intranet";
  }
  {
    key = "c";
    desc = "Community";
    cmd = "profilebrowser Community";
  }
  {
    key = "v";
    desc = "VPN";
    cmd = "profilebrowser VPN";
  }
]
++ lib.optionals (osConfig.networking.hostName == "main") [
  {
    key = "a";
    desc = "Anime";
    cmd = "profilebrowser Anime";
  }
]
