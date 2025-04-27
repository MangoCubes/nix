{
  config,
  inputs,
  hostname,
  ...
}:
{
  # imports = [ inputs.secrets.nixosModules.test ];
  # builtins.trace config.domains
  programs.bash = {
    shellAliases =
      let
        reloadSecrets = "sudo nix flake update secrets --flake ${config.home.homeDirectory}/Sync/NixConfig";
        remotes = inputs.secrets.addresses.global;
        cmds = builtins.foldl' (
          acc: hostname:
          let
            ip = remotes.${hostname};
          in
          acc
          // {
            "rebuild-${hostname}" =
              "${reloadSecrets} && nixos-rebuild --flake ${config.home.homeDirectory}/Sync/NixConfig#${hostname} --target-host main@${ip} --use-remote-sudo switch";
          }
        ) { } (builtins.attrNames remotes);
      in
      {
        genimage = "nix build ~/Sync/NixConfig#nixosConfigurations.build-qcow2.config.system.build.qcow2 --impure";
        rebuild = ''${reloadSecrets} && sudo nixos-rebuild --flake path://${config.home.homeDirectory}/Sync/NixConfig#${hostname} switch'';
        rebuildp = ''${reloadSecrets} && sudo nixos-rebuild --flake path://${config.home.homeDirectory}/Sync/NixConfig#${hostname}Presentation switch'';
        rebuildr = "rebuild && reboot";
        rebuilds = reloadSecrets;
        updateunstable = "nix flake update --flake path://${config.home.homeDirectory}/Sync/NixConfig unstablePkg";
        # Bunch of commands I seem to use a lot
        listen = "nc -lk";
      }
      // cmds;
  };
}
