{ pkgs, ... }:
{
  programs.git = {
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
