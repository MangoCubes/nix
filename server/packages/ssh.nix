{ username, lib, ... }:
{
  services.openssh = {
    enable = true;
    settings = lib.mkForce {
      PasswordAuthentication = true;
      AllowUsers = [ username ]; # Allows all users by default. Can be [ "user1" "user2" ]
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      AcceptEnv = null;
    };
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
}
