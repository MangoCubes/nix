{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  custom.bookmarks = {
    Root = {
      path = "/";
      keys = [ "/" ];
    };
    Trash = {
      path = "${home}/.local/share/Trash/files";
      keys = [ "T" ];
    };
    Temp = {
      path = "${home}/Temp";
      keys = [ "t" ];
    };
    Downloads = {
      path = "${home}/Downloads";
      keys = [ "d" ];
    };
    "Local Documents" = {
      path = "${home}/LocalDocuments";
      keys = [ "L" ];
    };

    Nextcloud = {
      path = "${home}/Nextcloud";
      keys = [ "N" ];
    };
    Projects = {
      path = "${home}/Nextcloud/Projects";
      keys = [ "p" ];
    };
    "Important Documents" = {
      path = "${home}/Nextcloud/Documents/Important";
      keys = [ "I" ];
    };
    "School Files" = {
      path = "${home}/Nextcloud/Documents/School";
      keys = [ "S" ];
    };
    "Current Researches" = {
      path = "${home}/Nextcloud/Documents/School/Research/Current";
      keys = [ "C" ];
    };

    Quick = {
      path = "${home}/Sync/Quick";
      keys = [ "Q" ];
    };
    QuickSecure = {
      path = "${home}/Sync/QuickSecure";
      keys = [ "q" ];
    };
    Notes = {
      path = "${home}/Sync/Notes";
      keys = [ "n" ];
    };

    Sync = {
      path = "${home}/Sync";
      keys = [
        "s"
        "s"
      ];
    };
    GeneralConfig = {
      path = "${home}/Sync/GeneralConfig";
      keys = [
        "s"
        "g"
      ];
    };
    LinuxConfig = {
      path = "${home}/Sync/LinuxConfig";
      keys = [
        "s"
        "l"
      ];
    };
    NixConfig = {
      path = "${home}/Sync/NixConfig";
      keys = [
        "s"
        "n"
      ];
    };
    NixEnv = {
      path = "${home}/Sync/NixEnv";
      keys = [
        "s"
        "N"
      ];
    };
    Passwords = {
      path = "${home}/Sync/Passwords";
      keys = [
        "s"
        "p"
      ];
    };

    "Local share" = {
      path = "${home}/.local/share";
      keys = [
        "l"
        "s"
      ];
    };
    "Local bin" = {
      path = "${home}/.local/bin";
      keys = [
        "l"
        "b"
      ];
    };
    "Local state" = {
      path = "${home}/.local/state";
      keys = [
        "l"
        "t"
      ];
    };

    Android = {
      path = "${home}/Mounts/Android";
      keys = [
        "m"
        "a"
      ];
    };
    Cloud = {
      path = "${home}/Mounts/Cloud";
      keys = [
        "m"
        "c"
      ];
    };
    Koofr = {
      path = "${home}/Mounts/Koofr";
      keys = [
        "m"
        "K"
      ];
    };
    Secrets = {
      path = "${home}/Mounts/Secrets";
      keys = [
        "m"
        "k"
      ];
    };
    server-main = {
      path = "${home}/Mounts/server-main";
      keys = [
        "m"
        "s"
      ];
    };
    Mounts = {
      path = "${home}/Mounts";
      keys = [
        "m"
        "m"
      ];
    };

    "Cloud Documents" = {
      path = "${home}/Mounts/Cloud/Documents";
      keys = [
        "c"
        "d"
      ];
    };
  };
}
