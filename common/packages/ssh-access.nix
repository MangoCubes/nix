# For remote access. My main user "main" has a weak password, but cannot be used for remote login.
# Instead, there is a user named "access" which has a strong password, but can be used to log in over SSH.
let
  sideUser = "access";
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ sideUser ]; # Allows all users by default. Can be [ "user1" "user2" ]
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
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
          startUid = 300000;
        }
      ];
      subGidRanges = [
        {
          count = 100000;
          startGid = 300000;
        }
      ];
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "shared"
      ];
      initialHashedPassword = "$y$j9T$y2TyywvD./5OrYhqqtXQD/$zeB5LXI/H8/CICFukZPFvUjOrhWGehTwPItXqpL93J1";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4atc4TqiG2UAl1NmeYNdiiRkkYd2HnCAP44D3575h8 ${sideUser}"
      ];
    };
  };
}
