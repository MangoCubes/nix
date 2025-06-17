{
  config,
  lib,
  pkgs,
  device,
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

in
{
  home.packages = [
    run-windows
  ];

  home.activation.windows = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/Windows/storage
    mkdir -p ${config.home.homeDirectory}/Windows/data
  '';
  # xdg.configFile."remmina/rdp.remmina".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/remmina/rdp.remmina";
  # xdg.configFile."remmina/remmina.pref".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/remmina/remmina.pref";
  services.podman.containers.windows = {
    image = "ghcr.io/dockur/windows:latest";
    autoStart = false;
    environment = {
      "VERSION" = "10";
      "RAM_SIZE" = "4G"; # RAM allocated to the Windows VM.
      "CPU_CORES" = "4"; # CPU cores allocated to the Windows VM.
      "DISK_SIZE" = "64G"; # Size of the primary hard disk.
      #DISK2_SIZE: "32G" # Uncomment to add an additional hard disk to the Windows VM. Ensure it is mounted as a volume below.
      "USERNAME" = "Windows"; # Edit here to set a custom Windows username. The default is 'MyWindowsUser'.
      "PASSWORD" = "Password"; # Edit here to set a password for the Windows user. The default is 'MyWindowsPassword'.
      "HOME" = "${config.home.homeDirectory}/Windows"; # Set path to Linux user home folder.
      "LANGUAGE" = "Korean";
    };
    ports = [
      "8006:8006"
      "3389:3389/tcp"
      "3389:3389/udp"
    ];
    volumes = [
      "${config.home.homeDirectory}/Windows/data:/data"
      "${config.home.homeDirectory}/Windows/storage:/storage"
    ];
    devices = [
      "/dev/kvm"
      "/dev/net/tun"
    ];
  };
}
