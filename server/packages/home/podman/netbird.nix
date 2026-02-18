{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "proton-exit" ];
      # addCapabilities = [
      #   "NET_ADMIN"
      #   "SYS_ADMIN"
      #   "SYS_RESOURCE"
      # ];
      network = [ "container:proton-exit" ];
      image = "netbirdio/netbird:rootless-latest";
      name = "netbird";
      # devices = [ "/dev/net/tun" ];
      environment = {
        NB_MANAGEMENT_URL = "https://vpn.skew.ch";
      };
      # volumes = [
      #   "netbird-client:/var/lib/netbird"
      # ];
    })
  ];
}
