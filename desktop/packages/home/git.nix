{ pkgs, ... }:
{
  programs.git = {
    signing.format = "openpgp";
    enable = true;
    package = pkgs.gitFull;
    settings = {
      credential.helper = "libsecret";
      init.defaultBranch = "master";
      user = {
        email = "10383115+MangoCubes@users.noreply.github.com";
        name = "MangoCubes";
      };
    };
  };
}
