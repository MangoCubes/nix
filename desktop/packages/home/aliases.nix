{
  config,
  inputs,
  ...
}:
let
  aliases =
    let
      reloadSecrets = "nix flake update secrets --flake ${config.home.homeDirectory}/Sync/NixConfig";
      remotes = inputs.secrets.servers;
      cmds = builtins.foldl' (
        acc: hostname:
        acc
        // {
          "rebuild-${hostname}" =
            "${reloadSecrets} && NIX_SSHOPTS=-A nixos-rebuild --flake ${config.home.homeDirectory}/Sync/NixConfig#${hostname} --target-host main@${hostname} --sudo --diff switch";
        }
      ) { } remotes;
    in
    {
      # Bunch of commands I seem to use a lot
      listen = "nc -lk $@";
    }
    // cmds;
in
{
  custom.shell.aliases = aliases;
}
