{
  config,
  lib,
  pkgs,
  device,
  ...
}:
let
  username = "Windows";
  password = "Password";
  container = ''podman run -d --name windows --env CPU_CORES=4 --env DISK_SIZE=64G --env HOME=/home/main/Windows --env LANGUAGE=Korean --env PASSWORD=Password --env RAM_SIZE=4G --env USERNAME=${username} --env VERSION=10 --device /dev/kvm --device /dev/net/tun --publish 8006:8006 --publish 3389:3389/tcp --publish 3389:3389/udp --volume ${config.home.homeDirectory}/Windows/data:/data --volume ${config.home.homeDirectory}/Windows/storage:/storage ghcr.io/dockur/windows:latest'';
  start-rdp = pkgs.writeShellScriptBin "run-windows" ''
    # Container name
    CONTAINER_NAME="windows"

    # Check if the container exists
    if podman ps -a --format '{{.Names}}' | grep -w "$CONTAINER_NAME" > /dev/null; then
      # Container exists
      if podman ps --format '{{.Names}}' | grep -w "$CONTAINER_NAME" > /dev/null; then
        # Container is running
        echo "Container '$CONTAINER_NAME' is already running."
      else
        # Container is stopped, start it
        echo "Starting container '$CONTAINER_NAME'."
        podman rm -f "$CONTAINER_NAME"
        ${container}
      fi
    else
      echo "Creating container '$CONTAINER_NAME'."
      ${container}
    fi

    ${pkgs.freerdp3}/bin/xfreerdp /cert:tofu /d:"" /u:"${username}" /p:"${password}" /scale:${
      toString (if device.scale == 2 then 180 else 100)
    } -grab-keyboard +clipboard /t:Windows +home-drive -wallpaper +dynamic-resolution /v:"127.0.0.1"
  '';

in
{
  home.packages = [
    start-rdp
  ];

  home.activation.windows = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/Windows/storage
    mkdir -p ${config.home.homeDirectory}/Windows/data
  '';
  # xdg.configFile."remmina/rdp.remmina".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/remmina/rdp.remmina";
  # xdg.configFile."remmina/remmina.pref".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/remmina/remmina.pref";
}
