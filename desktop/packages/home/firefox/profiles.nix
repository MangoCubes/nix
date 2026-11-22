{ hostname, lib }:
[
  {
    name = "School";
    alias = [ "Research" ];
    id = 1;
  }
  {
    name = "Intranet";
    alias = [
      "Proxmox"
      "Local"
    ];
    id = 2;
  }
  {
    name = "Community";
    id = 3;
  }
  {
    name = "VPN";
    vpn = true;
    id = 4;
  }
  {
    name = "Sandbox";
    alias = [
      "Ephemeral"
      "Temporary"
    ];
    resetOnClose = true;
    id = 0;
  }
]
++ lib.optionals (hostname == "main") [
  {
    name = "Anime";
    id = 5;
  }
]
