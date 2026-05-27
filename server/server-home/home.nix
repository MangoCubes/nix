{ ... }:
{
  home-manager.users.test =
    {
      inputs,
      ...
    }:
    {
      imports = [
        inputs.secrets.server-home.home
      ];
    };
}
