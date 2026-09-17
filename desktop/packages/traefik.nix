{
  username,
  pkgs,
  lib,
  inputs,
  ...
}:
((import ../../common/packages/podman/traefik.nix) {
  inherit
    pkgs
    username
    lib
    inputs
    ;
})
