{
  username,
  pkgs,
  lib,
  ...
}:
let
  dynamic = { };
  static = {
    # This is necessary to break the loop
    # When other servers refer to ca.local, it refers to Step CA via server-network's Traefik
    # However, server-network's Traefik needs to refer to the Step CA
    certificatesResolvers.localca.acme = {
      caServer = "https://ca:9000/acme/intranet/directory";
      email = "traefik@mail.local";
      tlsChallenge = true;
      storage = "/etc/traefik/ssl/local.json";
    };
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
