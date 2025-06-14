{
  pkgs,
  config,
  unstable,
  ...
}:
let
  run-windows = pkgs.writeShellScriptBin "run-windows" ''
    SERVICE_NAME="podman-windows"  # Replace with your service name

    if systemctl --user is-active --quiet $SERVICE_NAME; then
        echo "$SERVICE_NAME is already running."
    else
        echo "$SERVICE_NAME is not running. Starting it now..."
        systemctl --user start $SERVICE_NAME

        # Optionally, check if the service started successfully
        if systemctl --user is-active --quiet $SERVICE_NAME; then
            echo "$SERVICE_NAME started successfully."
        else
            echo "Failed to start $SERVICE_NAME."
            exit 1
        fi
    fi
    ${unstable.remmina}/bin/remmina -c ${config.home.homeDirectory}/.config/remmina/rdp.remmina
  '';
in

{
  home.packages =
    (with pkgs; [
      playerctl
      niri
    ])
    ++ [
      run-windows
    ];
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/niri/config.kdl";
}
