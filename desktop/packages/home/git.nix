{ pkgs, ... }:
{
  programs.lazygit.enableZshIntegration = true;
  home.packages = [ pkgs.lazygit ];
  programs.git = {
    signing.format = "openpgp";
    enable = true;
    package = pkgs.gitFull;
    settings = {
      credential.helper = "libsecret";
      user = {
        email = "10383115+MangoCubes@users.noreply.github.com";
        name = "MangoCubes";
      };
    };
  };
}
