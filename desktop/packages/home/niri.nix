{
  pkgs,
  config,
  hostname,
  ...
}:
let
  configFile = if hostname == "work" then ./niri/config-work.kdl else ./niri/config.kdl;
  killclick = pkgs.writeShellScriptBin "killclick" ''kill -9 $(niri msg pick-window | grep PID | tail -n 1 | awk '{print $NF}')'';
in
{
  home.packages = [
    killclick
  ]
  ++ (with pkgs; [
    playerctl
    niri
  ]);
  xdg.configFile."niri/config.kdl".text = (builtins.readFile configFile);
  # xdg.configFile."niri/config.kdl".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/niri/${configFile}";
}
