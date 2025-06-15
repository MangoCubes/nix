{
  pkgs,
  config,
  device,
  hostname,
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
    DISPLAY=:0 ${pkgs.freerdp3}/bin/xfreerdp /cert:tofu /d:"" /u:"Windows" /p:"Password" /scale:${
      toString (if device.scale == 2 then 180 else 100)
    } -grab-keyboard +clipboard /t:Windows +home-drive -wallpaper +dynamic-resolution /v:"127.0.0.1"
  '';
  configFile = if hostname == "work" then "config-work.kdl" else "config.kdl";
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
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/niri/${configFile}";
}
