{
  config,
  inputs,
  hostname,
  pkgs,
  ...
}:
let
  writeAlias =
    a: builtins.attrValues (builtins.mapAttrs (key: value: (pkgs.writeShellScriptBin key value)) a);
  aliases =
    let
      reloadSecrets = "sudo nix flake update secrets --flake ${config.home.homeDirectory}/Sync/NixConfig";
      remotes = inputs.secrets.servers;
      cmds = builtins.foldl' (
        acc: hostname:
        acc
        // {
          "rebuild-${hostname}" =
            "${reloadSecrets} && nixos-rebuild --flake ${config.home.homeDirectory}/Sync/NixConfig#${hostname} --target-host main@${hostname} --sudo --ask-sudo-password switch";
        }
      ) { } remotes;
    in
    {
      genimage = "nix build ~/Sync/NixConfig#nixosConfigurations.build-qcow2.config.system.build.qcow2 --impure";
      # Bunch of commands I seem to use a lot
      listen = "nc -lk $@";
      optimise = "nix-store --optimise";
    }
    // cmds;
in
{
  home.packages = (writeAlias aliases);
}
