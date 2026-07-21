{ username, lib, ... }:
# For remote access. My main user "main" has a weak password, but cannot be used for remote login.
# Instead, there is a user named "access" which has a strong password, but can be used to log in over SSH.
# main user: Public key auth only, can use sudo
# access user: Public key auth and password
# test user: Nothing
let
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
        "access"
      ];
      DenyUsers = [ "test" ];
      PermitRootLogin = "no";
      AcceptEnv = lib.mkForce null;
    };
    extraConfig = builtins.concatStringsSep "\n" [
      (allowPassword {
        allow = true;
        username = "access";
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
}
