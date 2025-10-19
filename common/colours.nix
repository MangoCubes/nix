let
  base = {
    miku = "47c8c0";
    teto = "ff629d";
    blackBg = "000000";
    lightBg = "5a676b";
    darkBg = "24292b";
    rin = "ffcc11";
  };
in
{
  inherit base;
  withTransparency = {
    miku = "${base.miku}ff";
    teto = "${base.teto}ff";
    rin = "${base.rin}ff";
    lightBg = "${base.lightBg}d0";
    darkBg = "${base.darkBg}d0";
    blackBg = "${base.blackBg}d0";
  };
}
