 
{ username, ... }:
{
  home-manager.users."${username}" = (import ./home.nix);
}
