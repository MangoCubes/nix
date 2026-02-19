{
  username,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}:
((import ../../common/packages/podman/traefik.nix) {
  inherit
    hostname
    pkgs
    username
    lib
    inputs
    ;
})
