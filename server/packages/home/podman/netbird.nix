{
  custom.podman.containers.netbird = {
    vpn = "exit";
    image = "netbirdio/netbird:rootless-latest";
    # devices = [ "/dev/net/tun" ];
    environment = {
      NB_MANAGEMENT_URL = "https://vpn.skew.ch";
    };
    volumes = [
      "netbird-client:/var/lib/netbird"
    ];
  };
}
