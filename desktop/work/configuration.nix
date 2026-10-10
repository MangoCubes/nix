{ inputs, unfreeUnstable, ... }:
{
  virtualisation.vmware.host = {
    package = unfreeUnstable.vmware-workstation;
    enable = true;
  };
  services.printing.enable = true;
  custom.device = {
    type = "desktop";
    scale = 1.5;
    monitors = [
      {
        x = 3840;
        y = 2160;
      }
      {
        x = 3840;
        y = 2160;
      }
    ];
  };
  imports = [
    inputs.secrets.desktop.work
    ./boot.nix
    ./home.nix
    ../packages/avahi.nix
    ../packages/wireshark.nix
    ../packages/mitmproxy-wifi.nix
    ../packages/afl.nix
  ];
  custom.android.enable = true;
  networking.wireless = {
    enable = true;
    userControlled = true;
  };
}
