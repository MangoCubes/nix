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
  static = {
    certificatesResolvers.letsencrypt.acme = {
      email = "postmaster@skew.ch";
      storage = "/etc/traefik/ssl/letsencrypt.json";
      httpChallenge.entryPoint = "web";
    };
    #accessLog.addInternals = false;
  };
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
