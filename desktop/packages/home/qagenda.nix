{ inputs, ... }:
{
  imports = [ inputs.qagenda.homeManager.default ];
  programs.qagenda = {
    enable = true;
  };
}
