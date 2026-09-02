{ pkgs, config, ... }:
let
  owl = pkgs.callPackage (
    {
      stdenv,
      fetchFromGitHub,
      cmake,
      pkg-config,
      libpcap,
      libev,
      libnl,
    }:

    stdenv.mkDerivation {
      pname = "owl";
      version = "unstable-master";

      src = fetchFromGitHub {
        owner = "MangoCubes";
        repo = "owl";
        rev = "0dcc85eeefea36736036ebe9481076932acee400";
        fetchSubmodules = true;
        hash = "sha256-gNSaR7kkEb1BzWN6tBNJj5Etq+KZ+dbj+MLE4GcYocI=";
      };

      nativeBuildInputs = [
        cmake
        pkg-config
      ];
      buildInputs = [
        libpcap
        libev
        libnl
      ];

      cmakeFlags = [
        "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      ];
    }
  ) { };
in
{
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "awdl0" ];
  };
  environment.systemPackages = [ owl ];
  #
  # systemd.services.open-wireless-link = {
  #   description = "Open Wireless Link (AWDL Daemon)";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStartPre = [
  #       "${pkgs.iproute2}/bin/ip link set ${config.custom.networking.secondary} down"
  #       "${pkgs.iproute2}/bin/ip link set ${config.custom.networking.secondary} promisc on"
  #     ];
  #     ExecStart = "${owl}/bin/owl -i ${config.custom.networking.secondary}";
  #     ExecStopPost = [
  #       "${pkgs.iproute2}/bin/ip link set ${config.custom.networking.secondary} promisc off"
  #       "${pkgs.iproute2}/bin/ip link set ${config.custom.networking.secondary} up"
  #     ];
  #     Restart = "on-failure";
  #     RestartSec = "5s";
  #     CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
  #     AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
  #   };
  # };
}
