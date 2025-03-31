{ lib, ... }:
let
  extensionsBase = {
    "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
    # uBlock Origin
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    # KeepassXC
    "keepassxc-browser@keepassxc.org" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
      installation_mode = "force_installed";
    };
    # MIKU THEME
    "{746ecd4b-0121-453a-862d-e378c0254733}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/sleeping-hatsune-miku-animate2/latest.xpi";
      installation_mode = "force_installed";
    };
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
      installation_mode = "force_installed";
    };
  };
in
let
  network = extensionsBase // {
    # Simplelogin
    "addon@simplelogin" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/simplelogin/latest.xpi";
      installation_mode = "force_installed";
    };
    # NoScript
    "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/noscript/latest.xpi";
      installation_mode = "force_installed";
    };
  };
in
let
  profiles = (import ./firefox/profiles.nix);
  policy = plugins: {
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    DisablePocket = true;
    DisableFirefoxAccounts = true;
    DisableAccounts = false;
    # DisableFirefoxScreenshots = true;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    DontCheckDefaultBrowser = true;
    DisplayBookmarksToolbar = "always"; # alternatives: "always" or "newtab"
    DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
    SearchBar = "unified"; # alternative: "separate"
    ExtensionSettings = plugins;
    DisableSetDesktopBackground = true;
  };
  searches = (import ./firefox/search.nix);
in
let
  genProfile =
    {
      name,
      id,
      internal ? false,
      engines ? [ ],
    }:
    {
      "${name}" = lib.mkMerge [
        {
          inherit id;
          isDefault = (id == 0);
          name = "${name}";
          settings = ((import ./firefox/base.nix) { inherit internal lib; });
        }
        (lib.mkIf ((builtins.length engines) != 0) {
          search = {
            engines = (lib.mkMerge (map (k: { "${k}" = searches."${k}"; }) engines));
            force = true;
          };
        })
      ];
    };
in
{
  programs.firefox = {
    enable = true;
    policies = (policy network);
    profiles = (lib.mkMerge (map genProfile profiles));
  };
}
