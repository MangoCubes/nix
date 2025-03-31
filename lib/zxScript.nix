# https://stackoverflow.com/questions/75220001/nix-write-google-zx-script-that-is-invokable-without-the-mjs-extension
# Import using `writeZxScriptBin = pkgs.callPackage ./zxScript.nix {};`

{ pkgs }:

name: text:

let
  mjsBin = pkgs.writeTextFile {
    name = "${name}-mjs";
    executable = true;
    # For Google ZX, the .mjs extension is mandatory.
    destination = "/bin/${name}.mjs";
    text = ''
      #!${pkgs.zx}/bin/zx
      ${text}
    '';
  };
in
# Shebang script enables to call the zx-script without the .mjs version.
pkgs.writeTextFile {
  name = "${name}";
  executable = true;
  destination = "/bin/${name}";
  text = ''
    #!${mjsBin}/bin/${name}.mjs
  '';
}
