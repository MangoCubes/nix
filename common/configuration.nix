{
  imports = [
    ./time.nix
    ./users.nix
    ./environment.nix
    ./networking.nix
    ./security.nix
    ./home.nix
    ./packages/podman.nix
    ./packages/tailscale.nix
    ./zsh.nix
    ./nix.nix
    ./packages/ssh-access.nix
  ];
}
