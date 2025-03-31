{ pkgs }: pkgs.writeShellScriptBin "rofi-search" ''${pkgs.python3}/bin/python ${./rofi-search.py}''
