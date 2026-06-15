{ hostname }:
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
    name = "Sandbox";
    alias = [
      "Ephemeral"
      "Temporary"
    ];
    resetOnClose = true;
    id = 0;
  }
]
++ (
  if hostname == "main" then
    [
      {
        name = "Anime";
        id = 5;
      }
    ]
  else
    [ ]
)
