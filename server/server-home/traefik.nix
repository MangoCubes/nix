{
  username,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}:
let
  traefikFile = (inputs.secrets.server-home.traefik);
in
((import ../../common/packages/podman/traefik.nix) {
  inherit
    hostname
    username
    inputs
    pkgs
    lib
    ;
  dynamic = traefikFile.dynamic;
  static = traefikFile.static;
})
