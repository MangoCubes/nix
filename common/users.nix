{ username, ... }:
{
  nix.settings.trusted-users = [ "@wheel" ];
  users.users = {
    "${username}" = {
      # Stop killing my fucking containers pls
      linger = true;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "shared"
      ]; # Enable ‘sudo’ for the user.
      # Other stuffs are in secrets
    };
    test = {
      isNormalUser = true;
      extraGroups = [ "shared" ];
    };
  };

  users.groups.shared = { };
}
