{
  config,
  lib,
  pkgs,
  ...
}:
let
  freerdp = (
    pkgs.freerdp.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libpng ];
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [
        "-DWINPR_UTILS_IMAGE_PNG=ON"
      ];
    })
  );
  username = "Windows";
  password = "Password";
  rdpCmd = "${freerdp}/bin/sdl-freerdp /u:${username} /p:${password} /dynamic-resolution /drive:shared,${config.home.homeDirectory} /v:127.0.0.1";
  run-windows = pkgs.writeShellScriptBin "run-windows" ''
    if systemctl --user is-active --quiet "podman-windows"; then
        ${pkgs.libnotify}/bin/notify-send "Opening RDP..." "Windows is already running.";
    else
        ${pkgs.libnotify}/bin/notify-send "Booting Windows..." "Windows container is starting.";
        systemctl --user start podman-windows;
    fi
    ${rdpCmd}
  '';
  remoteRdp = pkgs.writeShellScriptBin "rdp" ''${freerdp}/bin/sdl-freerdp /v:$@ /u:$(secret-tool search Title 'Windows RDP' 2>&1 >/dev/null | sed -n 's/^attribute\.UserName = //p') /p:$(secret-tool lookup Title 'Windows RDP') /dynamic-resolution /drive:shared,${config.home.homeDirectory}'';

in
{
  home.packages = [
    freerdp
    remoteRdp
    run-windows
  ];
  custom.windows = true;
  custom.podman.containers.windows = {
    autoStart = false;
    image = "ghcr.io/dockur/windows:latest";
    network = lib.mkForce [ ];
    mounts = [
      {
        inside = "/storage";
        outside = "${config.home.homeDirectory}/Windows/storage";
        create = true;
      }
      {
        inside = "/data";
        outside = "${config.home.homeDirectory}/Windows/data";
        create = true;
      }
    ];
    environment = {
      VERSION = "10";
      USERNAME = username;
      RAM_SIZE = "4G";
      PASSWORD = password;
      LANGUAGE = "Korean";
      HOME = "${config.home.homeDirectory}/Windows";
      DISK_SIZE = "16G";
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
  };
}
