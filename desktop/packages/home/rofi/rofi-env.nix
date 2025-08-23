{ pkgs, ... }:
let
  checkinternet = pkgs.writeShellScriptBin "checkinternet" ''
    # If second argument is not provided, just run the first command
    if [ -z "$2" ]; then
        echo "No fallback command provided. Running primary command only."
        echo "Running: $1"
        eval "$1"
        exit 0
    fi

    ping_host() {
        local host="$1"
        ping -w 5000 -c 1 "$host" > /dev/null 2>&1
        return $?
    }

    # Function to ping multiple hosts with fallback
    ping_multiple_with_fallback() {
        local hosts=("skew.ch" "genit.al" "1.1.1.1" "8.8.8.8")
        for host in "''${hosts[@]}"; do
            if ping_host "$host"; then
                return 0
            fi
        done
        return 1
    }

    echo "Checking if internet is available..."
    if ping_multiple_with_fallback; then
        echo "Ping successful."
        echo "Running primary command: $1"
        eval "$1"
    else
        echo "Ping failed. Using local data."
        echo "Running fallback command: $2"
        eval "$2"
    fi
  '';
  rofi-env = pkgs.writeShellScriptBin "rofi-env" ''${pkgs.python3}/bin/python ${./env/env.py} $@'';
in
{
  home.packages = [
    rofi-env
    checkinternet
  ];
}
