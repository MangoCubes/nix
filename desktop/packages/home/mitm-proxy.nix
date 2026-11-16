{
  pkgs,
  config,
  secrets,
  ...
}:
let
  wireproxy = pkgs.writeShellScriptBin "wireproxy" "${pkgs.wireproxy}/bin/wireproxy -c ${config.sops.secrets.mitm-wireproxy.path}";
in
{
  imports = [ secrets.desktop.packages.home.mitm-proxy ];
  home.packages = [ wireproxy ];
}
