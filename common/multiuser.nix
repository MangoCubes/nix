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
            ./packages/home/zsh.nix
            ./packages/home/scripts.nix
            ./packages/home/tmux.nix
          ];
        };
    })
    [
      username
      "access"
    ]
)
