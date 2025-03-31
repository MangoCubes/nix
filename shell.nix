{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  # tokei -e "*.d.ts"
  packages = [ pkgs.tokei ];
}
