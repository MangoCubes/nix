{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    settings.customCommands = [
      {
        key = "<c-a>";
        context = "files";
        command = "git commit --amend --no-edit --no-verify";
        description = "Amend last commit without hooks";
        loadingText = "Amending...";
      }
    ];
  };
  programs.git = {
    signing.format = "openpgp";
    enable = true;
    package = pkgs.gitFull;
    settings = {
      credential.helper = "libsecret";
      pull.rebase = false;
      user = {
        email = "10383115+MangoCubes@users.noreply.github.com";
        name = "MangoCubes";
      };
    };
  };
}
