{ pkgs, ... }:
{
  xdg.configFile."iamb/config.toml".source = (
    (pkgs.formats.toml { }).generate "config.toml" {
      profiles.main = {
        user_id = "@main:skew.ch";
        url = "https://matrix.skew.ch";
      };
    }
  );
  home.packages = [
    pkgs.iamb
  ];
}
