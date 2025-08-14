{ pkgs, config, ... }:
let
  browser = pkgs.writeShellScriptBin "browser" ''qutebrowser --temp-basedir -C ${config.home.homeDirectory}/.config/qutebrowser/config-internet.py -s window.title_format "{perc}Temp{title_sep}{current_title}" "$@"'';
  profilebrowser = pkgs.writeShellScriptBin "profilebrowser" ''qutebrowser -B ${config.home.homeDirectory}/Sync/Browsers/$@ -C "${config.home.homeDirectory}/.config/qutebrowser/config-$@.py" -s window.title_format "{perc}$@{title_sep}{current_title}" '';
in
{
  home.packages = [
    pkgs.qutebrowser
    profilebrowser
    browser
  ];
  xdg.configFile."qutebrowser".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/qute";
  xdg = {
    mimeApps.defaultApplications = {
      "application/pdf" = "org.qutebrowser.qutebrowser.desktop";
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    };
  };
}
