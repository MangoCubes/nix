{
  username,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  rangeSize = 100000;
  mkUser = index: {
    shell = pkgs.zsh;
    subUidRanges = [
      {
        count = rangeSize;
        startUid = index * rangeSize + 1;
      }
    ];
    subGidRanges = [
      {
        count = rangeSize;
        startGid = index * rangeSize + 1;
      }
    ];
    isNormalUser = true;
  };
in
{
  nix.settings.trusted-users = [ "@wheel" ];
  imports = [
    # Other stuffs are in secrets
    inputs.secrets.common.users
  ];

  users.users = builtins.listToAttrs (
    lib.imap1
      (index: user: {
        name = user.name;
        value = (mkUser index) // user.config;
      })
      [
        {
          name = username;
          config = {
            # Stop killing my fucking containers pls
            linger = true;
            extraGroups = [
              "wheel"
              "shared"
            ]; # Enable ‘sudo’ for the user.
          };
        }
        {
          name = "test";
          config.extraGroups = [ "shared" ];
        }
        {
          name = "access";
          config = {
            initialHashedPassword = "$y$j9T$y2TyywvD./5OrYhqqtXQD/$zeB5LXI/H8/CICFukZPFvUjOrhWGehTwPItXqpL93J1";
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4atc4TqiG2UAl1NmeYNdiiRkkYd2HnCAP44D3575h8 access"
            ];
          };
        }
      ]
  );

  users.groups = {
    shared = { };
  };
}
