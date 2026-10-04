{
  pkgs,
  config,
  inputs,
  ...
}:
let
  wireproxy = pkgs.writeShellScriptBin "wireproxy" "${pkgs.wireproxy}/bin/wireproxy -c ${config.sops.secrets.mitm-wireproxy.path}";
in
{
  imports = [ inputs.secrets.hm.mitm-proxy ];
  home.packages = [ wireproxy ];
}
