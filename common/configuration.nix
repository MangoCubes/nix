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
    ./packages/podman.nix
    ./packages/tailscale.nix
    ./nix.nix
    ./packages/ssh-access.nix
  ];
}
