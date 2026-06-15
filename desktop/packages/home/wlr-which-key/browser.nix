{ hostname, ... }:
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
]
++ (
  if hostname == "main" then
    [
      {
        key = "a";
        desc = "Anime";
        cmd = "profilebrowser Anime";
      }
    ]
  else
    [ ]
)
