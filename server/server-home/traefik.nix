{
  username,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}:
let
  traefikFile = (
    lib.recursiveUpdate {
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
    } inputs.secrets.server-home.traefik
  );
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
