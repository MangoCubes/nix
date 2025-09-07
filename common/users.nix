{ username, inputs, ... }:
{
  nix.settings.trusted-users = [ "@wheel" ];
  imports = [
    inputs.secrets.common
  ];
  users.users = {
    "${username}" = {
      # Stop killing my fucking containers pls
      linger = true;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "shared"
        "ydotool"
      ]; # Enable ‘sudo’ for the user.
      # Other stuffs are in secrets
    };
    test = {
      isNormalUser = true;
      extraGroups = [ "shared" ];
    };
  };

  users.groups = {
    shared = { };
    ydotool = { };
  };
}
