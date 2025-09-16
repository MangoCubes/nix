{ ... }:
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
    key = "w";
    desc = " Run Windows";
    cmd = ''run-windows'';
  }
  {
    key = "b";
    desc = "󰖟 Open Blog Editor";
    cmd = ''emacs-web'';
  }
]
