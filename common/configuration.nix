{ device, ... }:
{
  # Import is basically "merge these files into this file"
  # This allows you to split files into multiple parts
  imports = [
    ./time.nix
    ./users.nix
    ./environment.nix
    ./networking.nix
    ./security.nix
    ./home.nix
    ./packages/netbird.nix
    ./nix.nix
  ]
  ++ (
    if device.type != "vm" then
      [
        ./packages/podman.nix
        ./packages/ssh-access.nix
      ]
    else
      [ ]
  );
}
