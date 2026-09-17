{
  username,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  traefikFile = (inputs.secrets.server-home.traefik);
in
((import ../../common/packages/podman/traefik.nix) {
  inherit
    username
    inputs
    pkgs
    lib
    ;
  dynamic = traefikFile.dynamic;
  static = traefikFile.static;
})
