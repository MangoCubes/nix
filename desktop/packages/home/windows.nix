{
  config,
  lib,
  unstable,
  ...
}:
let
  command = ''systemctl --user start podman-windows && ${unstable.remmina}/bin/remmina -c ${config.home.homeDirectory}/.config/remmina/rdp.remmina'';
in
{
  wayland.windowManager.hyprland.settings.bind = [
    ''SUPER SHIFT, W, exec, ${command}''
  ];
  home.activation.windows = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/Windows/storage
    mkdir -p ${config.home.homeDirectory}/Windows/data
  '';
  # xdg.configFile."windows/rdp.remmina".text = (builtins.readFile ./windows/rdp.remmina);
  xdg.configFile."remmina/rdp.remmina".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/remmina/rdp.remmina";
  home.packages = [
    unstable.remmina
  ];
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
