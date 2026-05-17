{
  username,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}:
let
  dynamic = { };
  static = { };
in
((import ../../common/packages/podman/traefik.nix) {
  inherit
    hostname
    username
    dynamic
    static
    inputs
    pkgs
    lib
    ;
})
