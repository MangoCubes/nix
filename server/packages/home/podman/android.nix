{
  config,
  pkgs,
  ...
}:
let
  # Ignore chown for /dev/kvm only
  chown = pkgs.writeScript "chown" ''
    #!/bin/sh
    /bin/chown "$@" || [ "$2" = /dev/kvm ]
  '';
  persist = [
    "emulator"
    ".android"
  ];
  hostPath = path: "${config.home.homeDirectory}/.podman/android/${path}";
  uid = 1300;
in
{
  custom.podman.containers.android = {
    inherit uid;
    image = "budtmo/docker-android:emulator_14.0";
    autoStart = false;
    disk.persistOnly = builtins.map (path: "android/${path}") persist;
    volumes = [
      "${chown}:/usr/local/sbin/chown:ro"
    ]
    ++ builtins.map (path: "${hostPath path}:/home/androidusr/${path}") persist;
    devices = [ "/dev/kvm" ];
    domain = [
      {
        url = "android.int";
        port = 6080;
      }
    ];
    environment = {
      EMULATOR_DEVICE = "Samsung Galaxy S10";
      WEB_VNC = "true";
      USER_BEHAVIOR_ANALYTICS = "false";
    };
    entrypoint = ''exec "$APP_PATH/mixins/scripts/run.sh"'';
  };
  services.podman.containers.android.extraConfig.Service.TimeoutStartSec = "infinity";
}
