{
  username,
  inputs,
  pkgs,
  ...
}:
{
  nix.settings.trusted-users = [ "@wheel" ];
  imports = [
    inputs.secrets.common
  ];

  users.users = {
    "${username}" = {
      shell = pkgs.zsh;
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
    access = {
      shell = pkgs.zsh;
      subUidRanges = [
        {
          count = 100000;
          startUid = 300001;
        }
      ];
      subGidRanges = [
        {
          count = 100000;
          startGid = 300001;
        }
      ];
      isNormalUser = true;
      extraGroups = [
        "shared"
      ];
      initialHashedPassword = "$y$j9T$y2TyywvD./5OrYhqqtXQD/$zeB5LXI/H8/CICFukZPFvUjOrhWGehTwPItXqpL93J1";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4atc4TqiG2UAl1NmeYNdiiRkkYd2HnCAP44D3575h8 access"
      ];
    };
    test = {
      shell = pkgs.zsh;
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
