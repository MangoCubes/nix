{ ... }:
let
  as-japanese = ''
    d browser https://ja.dict.naver.com;
    d xournalpp "/home/main/Documents/Self Study/Japanese/Kanji.xopp";
    d xournalpp;
  '';
in
[
  {
    key = "j";
    desc = "🇯🇵Japanese";
    cmd = as-japanese;
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
