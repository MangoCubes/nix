{ config, ... }:
let
  japanese = ''
    d browser https://ja.dict.naver.com;
    d xournalpp;
  '';
in
[
  {
    key = "j";
    desc = "🇯🇵Japanese";
    cmd = japanese;
  }
  {
    key = "m";
    desc = " View Mail";
    cmd = ''emacs-mail'';
  }
  {
    key = "b";
    desc = "󰖟 Open Blog Editor";
    cmd = ''emacs-web'';
  }
]
++ (
  if config.custom.features.windows then
    [
      {
        key = "w";
        desc = " Run Windows";
        cmd = ''run-windows'';
      }
      {
        key = "W";
        desc = " Stop Windows";
        cmd = ''sup podman-windows'';
      }
    ]
  else
    [ ]
)
