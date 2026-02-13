{ username, inputs, ... }:
{
  nix.settings.trusted-users = [ "@wheel" ];
  imports = [
    inputs.secrets.common
  ];
  users.users = {
    "${username}" = {
      subUidRanges = [
        {
          count = 100000;
          startUid = 100000;
        }
      ];
      subGidRanges = [
        {
          count = 100000;
          startGid = 100000;
        }
      ];
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
      subUidRanges = [
        {
          count = 100000;
          startUid = 200000;
        }
      ];
      subGidRanges = [
        {
          count = 100000;
          startGid = 200000;
        }
      ];
      isNormalUser = true;
      extraGroups = [ "shared" ];
    };
  };

  users.groups = {
    shared = { };
    ydotool = { };
  };
}
