{ inputs, ... }:
{
  imports = [ inputs.ampterm.homeManager.default ];
  programs.ampterm = {
    enable = true;
  };
}
