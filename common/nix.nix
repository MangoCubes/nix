{
  nix = {
    # Removes that nix channel thing, which is not useful in flake setup
    channel.enable = false;
    settings = {
      trusted-users = [ "@wheel" ];
      # This is necessary to enable flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      # Delete old logs
      keep-build-log = false;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
