{
  username,
  pkgs,
  lib,
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
    username
    dynamic
    static
    pkgs
    lib
    ;
})
