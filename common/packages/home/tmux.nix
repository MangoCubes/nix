{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    newSession = true;
    escapeTime = 0;
    mouse = true;
    clock24 = true;
    historyLimit = 50000;
    keyMode = "vi";
    prefix = "C-w";
    reverseSplit = true;
    customPaneNavigationAndResize = true;

    extraConfig = ''
      bind w select-pane -t :.+
    '';

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];
  };
}
