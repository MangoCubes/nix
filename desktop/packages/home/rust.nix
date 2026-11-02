{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];
  home.packages = [
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
    })
    pkgs.stdenv.cc
    pkgs.pkg-config
    pkgs.openssl
  ];
}
