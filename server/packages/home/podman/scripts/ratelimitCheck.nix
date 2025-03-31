{ pkgs, ... }:
let
  writeZxScriptBin = pkgs.callPackage ../../../../../lib/zxScript.nix { };
in
writeZxScriptBin ''ratelimitcheck'' (
  builtins.replaceStrings
    [
      "__pkgs.systemd__"
    ]
    [
      "${pkgs.systemd}"
    ]
    (builtins.readFile ./ratelimitCheck.mjs)
)
