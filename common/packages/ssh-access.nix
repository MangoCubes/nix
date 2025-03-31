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
