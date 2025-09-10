let
  base = {
    miku = "47c8c0";
    teto = "ff629d";
    blackBg = "000000";
    lightBg = "5a676b";
    darkBg = "24292b";
  };
in
{
  inherit base;
  withTransparency = {
    miku = "${base.miku}ff";
    lightBg = "${base.lightBg}d0";
    darkBg = "${base.darkBg}d0";
    blackBg = "${base.blackBg}d0";
  };
}
