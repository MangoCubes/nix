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
        owner = "seemoo-lab";
        repo = "owl";
        rev = "da255a70f221784c836d943dd3f243bc798f223b";
        fetchSubmodules = true;
        hash = "sha256-727xTLQ3a6a+yJWIyB33UNUI5wl4ZaO6bPkt+WNgYEM=";
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

      postPatch = ''
        substituteInPlace CMakeLists.txt \
          --replace-fail 'add_subdirectory(googletest)' "" \
          --replace-fail 'add_subdirectory(tests)' ""
      '';
    }
  ) { };
in
{
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      # Port for letting desktops to connect to me
      # 34669
      # 45371
      8770
      41159
    ];
    allowedUDPPorts = [
      # Port for letting desktops to connect to me
      5353
    ];
    trustedInterfaces = [
      "awdl0"
    ];
  };

  environment.systemPackages = [ owl ];

  systemd.services.open-wireless-link = {
    description = "Open Wireless Link (AWDL Daemon)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.iproute2}/bin/ip link set ${config.custom.networking.secondary} down";
      ExecStart = "${owl}/bin/owl -i ${config.custom.networking.secondary}";
      ExecStopPost = "${pkgs.iproute2}/bin/ip link set ${config.custom.networking.secondary} up";
      Restart = "on-failure";
      RestartSec = "5s";
      CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
      AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
    };
  };
}
