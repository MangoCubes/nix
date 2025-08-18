{ pkgs, ... }:
let
  mb = pkgs.mullvad-browser;
  mbXdg = "mullvad-browser.desktop";
  browser = pkgs.writeShellScriptBin "browser" ''${mb}/bin/mullvad-browser "$@"'';
in
{
  home.packages = [
    browser
    mb
  ];
  xdg = {
    mimeApps.defaultApplications = {
      "application/pdf" = mbXdg;
      "text/html" = mbXdg;
      "x-scheme-handler/http" = mbXdg;
      "x-scheme-handler/https" = mbXdg;
    };
  };
}
