{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = "Windows";
  password = "Password";
  rdpCmd = "${pkgs.remmina}/bin/remmina /home/main/.local/share/remmina/rdp.remmina";
  run-windows = pkgs.writeShellScriptBin "run-windows" ''
    if systemctl --user is-active --quiet "podman-windows"; then
        ${pkgs.notify-desktop}/bin/notify-desktop "Opening RDP..." "Windows is already running.";
    else
        ${pkgs.notify-desktop}/bin/notify-desktop "Booting Windows..." "Windows container is starting.";
        systemctl --user start podman-windows;
    fi
    ${rdpCmd}
  '';

in
{
  home.packages = [
    run-windows
  ];
  imports = [
    ((import ../../../lib/podman.nix) {
      dependsOn = [ ];
      autoStart = false;
      image = "ghcr.io/dockur/windows:latest";
      name = "windows";
      volumes = [
        "${config.home.homeDirectory}/Windows/storage:/storage"
        "${config.home.homeDirectory}/Windows/data:/data"
      ];
      environment = {
        VERSION = "10";
        USERNAME = username;
        RAM_SIZE = "4G";
        PASSWORD = password;
        LANGUAGE = "Korean";
        HOME = "${config.home.homeDirectory}/Windows";
        DISK_SIZE = "64G";
        CPU_CORES = "4";
      };
      devices = [
        "/dev/net/tun"
        "/dev/kvm"
      ];
      ports = [
        "3389:3389/tcp"
        "3389:3389/udp"
        "8006:8006"
      ];
    })
  ];

  home.activation.windows = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/Windows/storage
    mkdir -p ${config.home.homeDirectory}/Windows/data
  '';
  xdg.dataFile."remmina/rdp.remmina".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/remmina/rdp.remmina";
  xdg.configFile."remmina".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/remmina";
}
