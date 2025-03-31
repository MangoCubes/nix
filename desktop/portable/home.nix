{
  imports = [
#     ../base/home.nix
  ];
  home = {
    stateVersion = "24.11";
    username = "main";
    homeDirectory = "/home/main";
  };

  programs.home-manager.enable = true;
}
