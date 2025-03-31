{ username, pkgs, ... }:
{
  users.users."${username}".extraGroups = [ "wireshark" ]; # Enable ‘sudo’ for the user.
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}

