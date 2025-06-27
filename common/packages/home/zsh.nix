{
  username,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    # history.ignorePatterns = [
    #   "rm *"
    #   "pkill *"
    #   "cp *"
    # ];
    shellAliases = {
      # Baseline commands only
      jl = "sudo journalctl -xeu";
      jul = "journalctl --user -xeu";
      ss = "sudo systemctl status";
      sr = "sudo systemctl restart";
      sp = "sudo systemctl stop";
      sus = "systemctl --user status";
      sur = "systemctl --user restart";
      sup = "systemctl --user stop";
      update = "sudo nix-channel --update";
      hml = "journalctl -u home-manager-${username}.service -b";
      gc = "sudo nix-collect-garbage -d";
      gch = "nix-collect-garbage -d";
      dol = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d";
      km = ''echo "Copy the following into hardware-configuration.nix to get the OS to reboot."; nixos-generate-config --show-hardware-config'';
      currentboot = ''journalctl -o short-precise -k'';
      lastboot = ''journalctl -o short-precise -k -b -1'';
    };
  };
}
