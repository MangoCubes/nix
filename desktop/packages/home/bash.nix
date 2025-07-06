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
            "${reloadSecrets} && nixos-rebuild --flake ${config.home.homeDirectory}/Sync/NixConfig#${hostname} --target-host main@${hostname} --use-remote-sudo switch";
        }
      ) { } remotes;
    in
    {
      genimage = "nix build ~/Sync/NixConfig#nixosConfigurations.build-qcow2.config.system.build.qcow2 --impure";
      rebuild = ''sudo nixos-rebuild --flake path://${config.home.homeDirectory}/Sync/NixConfig#${hostname} switch'';
      rebuildp = ''sudo nixos-rebuild --flake path://${config.home.homeDirectory}/Sync/NixConfig#${hostname}Presentation switch'';
      rebuilda = ''rebuilds && rebuild'';
      rebuildap = ''rebuilds && rebuildp'';
      rebuildr = "rebuild && reboot";
      rebuilds = reloadSecrets;
      rb = ''kitty sh -c "rebuild; read"'';
      updateunstable = "nix flake update --flake path://${config.home.homeDirectory}/Sync/NixConfig unstablePkg";
      # Bunch of commands I seem to use a lot
      listen = "nc -lk $@";
    }
    // cmds;
in
{
  home.packages = (writeAlias aliases);
}
