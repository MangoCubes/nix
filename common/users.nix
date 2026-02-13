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
          startUid = 100001;
        }
      ];
      subGidRanges = [
        {
          count = 100000;
          startGid = 100001;
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
          startUid = 200001;
        }
      ];
      subGidRanges = [
        {
          count = 100000;
          startGid = 200001;
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
