{
  username,
  lib,
  ...
}:
lib.mkMerge (
  builtins.map
    (u: {
      home-manager.users."${u}" =
        { ... }:
        {
          imports = [
            ./packages/home/atuin.nix
            ./packages/home/zsh.nix
            ./packages/home/scripts.nix
            ./packages/home/tmux.nix
            ./packages/home/yazi.nix
          ];
        };
    })
    [
      username
      "access"
    ]
)
