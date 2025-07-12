let
  icons = {
    nix = "https://wiki.nixos.org/favicon.png";
  };
  everyDay = 24 * 60 * 60 * 1000;
in
{
  "Nix Packages" = {
    urls = [
      {
        template = "https://search.nixos.org/packages";
        params = [
          {
            name = "type";
            value = "packages";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = icons.nix;
    updateInterval = everyDay;
    definedAliases = [ "@np" ];
  };

  "NixOS Wiki" = {
    urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
    icon = icons.nix;
    updateInterval = everyDay;
    definedAliases = [ "@nw" ];
  };
  "Home Manager Options" = {
    urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
    icon = icons.nix;
    updateInterval = everyDay;
    definedAliases = [ "@nw" ];
  };
}
