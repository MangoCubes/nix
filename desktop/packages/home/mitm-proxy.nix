{
  pkgs,
  config,
  inputs,
  ...
}:
let
  wireproxy = pkgs.writeShellScriptBin "wireproxy" ''${pkgs.wireproxy}/bin/wireproxy -c ${config.home.homeDirectory}/.config/sops-nix/secrets/mitm/wireproxy.conf'';
in
{
  imports = [
    inputs.secrets.hm.mitm-proxy
  ];
  home.packages = [
    wireproxy
  ];
}
