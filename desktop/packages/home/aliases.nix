{
  config,
  inputs,
  ...
}:
let
  aliases =
    let
      reloadSecrets = "nix flake update secrets --flake ${config.custom.bookmarks.NixConfig.path}";
      cmds = builtins.foldl' (
        acc: hostname:
        acc
        // {
          "rebuild-${hostname}" =
            "${reloadSecrets} && NIX_SSHOPTS=-A nixos-rebuild --flake ${config.custom.bookmarks.NixConfig.path}#${hostname} --target-host main@${hostname} --sudo --diff switch";
        }
      ) { } (builtins.attrNames inputs.self.nixosConfigurations);
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
