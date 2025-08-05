let
  as-japanese = ''
    d browser https://ja.dict.naver.com;
    d xournalpp "/home/main/Documents/Self Study/Japanese/Kanji.xopp";
    d xournalpp;
  '';
  theme = (import ./theme.nix);
  menu = [
    {
      key = "j";
      desc = "🇯🇵Japanese";
      cmd = as-japanese;
    }
  ];
in
theme // { inherit menu; }
