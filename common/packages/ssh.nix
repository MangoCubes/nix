{ username, lib, ... }:
# For remote access. My main user "main" has a weak password, but cannot be used for remote login.
# Instead, there is a user named "access" which has a strong password, but can be used to log in over SSH.
# main user: Public key auth only
# access user: Public key auth and password
# test user: Nothing
let
  sideUser = "access";
  allowPassword =
    { username, allow }:
    let
      val = if allow then "yes" else "no";
    in
    ''
      Match User ${username}
        PasswordAuthentication ${val}
        KbdInteractiveAuthentication ${val}
        PubkeyAuthentication yes
    '';
in
{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [
        username
        sideUser
      ];
      DenyUsers = [ "test" ];
      PermitRootLogin = "no";
      AcceptEnv = lib.mkForce null;
    };
    extraConfig = builtins.concatStringsSep "\n" [
      (allowPassword {
        allow = true;
        username = sideUser;
      })
      (allowPassword {
        allow = false;
        inherit username;
      })
    ];
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
  users.users = {
    "${sideUser}" = {
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4atc4TqiG2UAl1NmeYNdiiRkkYd2HnCAP44D3575h8 ${sideUser}"
      ];
    };
  };
}
