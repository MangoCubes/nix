{
  # Debugging NixOS when "Failed to start transient service unit..."
  # 1. journalctl -xe
  # 2. sudo systemctl stop nixos-rebuild-switch-to-configuration
  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      trusted-users = [ "@wheel" ];
      # This is necessary to enable flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
  };
}
