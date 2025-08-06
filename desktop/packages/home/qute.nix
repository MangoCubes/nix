{ pkgs, config, ... }:
let
  browser = pkgs.writeShellScriptBin "browser" ''qutebrowser --temp-basedir -C ${config.home.homeDirectory}/.config/qutebrowser/config.py $@'';
in
{
  home.packages = [
    pkgs.qutebrowser
    browser
  ];
  xdg.configFile."qutebrowser/config.py".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/qute/config.py";
  xdg = {
    mimeApps.defaultApplications = {
      "application/pdf" = "org.qutebrowser.qutebrowser.desktop";
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    };
  };
}
