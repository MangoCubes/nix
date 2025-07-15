{ pkgs, lib, ... }:
let
  printEngines = { name, ... }: name;
  printURL = { url, name }: ''if [[ "$name" == "${name}" ]]; then echo "${url}"; exit 0; fi'';
  engines = [
    {
      name = "DuckDuckGo";
      url = "https://duckduckgo.com/html/?q=";
    }
    {
      name = "Nix Packages";
      url = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=";
    }
    {
      name = "Home Manager";
      url = "https://home-manager-options.extranix.com/?release=master&query=";
    }
    {
      name = "IEEEXplore";
      url = "https://ieeexplore.ieee.org/search/searchresult.jsp?newsearch=true&queryText=";
    }
    {
      name = "Google";
      url = "https://www.google.com/search?q=";
    }
  ];
  rofi-engines = pkgs.writeShellScriptBin "rofi-engines" ''
    name=$(echo "${lib.strings.concatStringsSep "\n" (map printEngines engines)}" | rofi -dmenu)
    if [ -z "$name" ]; then exit 1; fi
    ${lib.strings.concatStringsSep "\n" (map printURL engines)}
    exit 1;
  '';
in
{
  home.packages = [ rofi-engines ];
}
