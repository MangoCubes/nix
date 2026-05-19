{
  username,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}:
let
  dynamic = {
    http = {
      serversTransports.insecure.insecureSkipVerify = true;
      routers.proxmox = {
        rule = "Host(`vm.int`)";
        service = "proxmox";
        entryPoints = [ "websecure" ];
        tls.certResolver = "localca";
      };
      services.proxmox.loadBalancer = {
        serversTransport = "insecure";
        servers = [
          { url = "https://host.containers.internal:8006"; }
        ];
      };
    };
  };
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
