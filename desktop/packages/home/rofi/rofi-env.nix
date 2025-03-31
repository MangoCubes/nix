{ pkgs }:
pkgs.writeShellScriptBin "rofi-env" ''${pkgs.python3}/bin/python ${./scripts/rofi-env.py} $@''
