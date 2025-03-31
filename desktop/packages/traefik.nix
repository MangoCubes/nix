{ username, pkgs, lib, ... }:
((import ../../common/packages/podman/traefik.nix) { inherit pkgs username lib; })
