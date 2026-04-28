{ hostname }:
[
  {
    name = "School";
    alias = [ "Research" ];
    id = 0;
  }
  {
    name = "Intranet";
    alias = [
      "Proxmox"
      "Debian"
      "Syncthing"
      "Local"
    ];
    id = 1;
  }
  {
    name = "SelfHosted";
    alias = [
      "Cloud"
      "Music"
    ];
    id = 2;
  }
  {
    name = "Development";
    id = 3;
    alias = [ "Flare" ];
    engines = [
      "Nix Packages"
      "NixOS Wiki"
      "Home Manager Options"
    ];
  }
  {
    name = "Community";
    id = 4;
  }
  {
    name = "Personal";
    alias = [ "Mail" ];
    id = 5;
  }
  {
    name = "Offline";
    id = 6;
    internal = true;
  }
  {
    name = "Sandbox";
    alias = [
      "Ephemeral"
      "Temporary"
    ];
    resetOnClose = true;
    id = 7;
  }
]
++ (
  if hostname == "main" then
    [
      {
        name = "Anime";
        id = 8;
      }
    ]
  else
    [ ]
)
