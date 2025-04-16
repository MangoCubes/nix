{ config, inputs, ... }:
{
  imports = [
    inputs.secrets.hm.accounts
  ];

  programs.khal = {
    enable = true;
  };
  services.mbsync.enable = true;
  programs.mbsync = {
    enable = true;
  };
  services.vdirsyncer.enable = true;
  programs.vdirsyncer.enable = true;
  programs.notmuch = {
    hooks.preNew = "mbsync --all";
    enable = true;
  };
  accounts = {
    email = {
      maildirBasePath = ".mail";
      accounts = {
        personal = {
          notmuch.enable = true;
          imapnotify.onNotifyPost = "";
          address = "admin@skew.ch";
          imap = {
            host = "mail.skew.ch";
            tls.enable = true;
          };
          smtp = {
            host = "mail.skew.ch";
            tls.enable = true;
          };
          mbsync = {
            enable = true;
            create = "both";
          };
          passwordCommand = [
            "cat"
            "${config.home.homeDirectory}/.config/sops-nix/secrets/mail"
          ];
          primary = true;
          realName = "Admin";
          userName = "admin@skew.ch";
        };
      };
    };
    calendar = {
      basePath = "./.calendar";
      accounts."personal" = {
        primary = true;
        vdirsyncer = {
          enable = true;
          auth = "basic";
          collections = [
            "from a"
            "from b"
          ];
        };
        remote = {
          passwordCommand = [
            "cat"
            "${config.home.homeDirectory}/.config/sops-nix/secrets/nextcloud"
          ];
          type = "caldav";
          url = "https://cloud.skew.ch/remote.php/dav";
          userName = "user";
        };
        primaryCollection = "post-grad";
        # Note that setting this variable does not automatically install khal
        # This merely grants khal access to this calendar
        khal = {
          enable = true;
          type = "discover";
        };
      };
    };
  };
}
