{ inputs, unfreeUnstable, ... }:
{
  virtualisation.vmware.host = {
    package = unfreeUnstable.vmware-workstation;
    enable = true;
  };
  services.printing.enable = true;
  imports = [
    inputs.secrets.desktop.work
    ./boot.nix
    ./home.nix
    ../packages/avahi.nix
    ../packages/wireshark.nix
    ../packages/mitmproxy-wifi.nix
    ../../common/troubleshooting.nix
    (import ../packages/android.nix {
      androidStudio = false;
      heimdall = false;
    })
  ];
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
}
