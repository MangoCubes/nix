{ pkgs }: pkgs.writeShellScriptBin "rofi-env" ''${pkgs.python3}/bin/python ${./env/env.py} $@''
