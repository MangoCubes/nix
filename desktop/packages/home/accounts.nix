{
  config,
  inputs,
  pkgs,
  unstable,
  ...
}:
{
  imports = [
    inputs.secrets.hm.accounts
  ];

  home.packages = [
    unstable.calcure
    pkgs.jq
  ];
  xdg.configFile."calcure/config.ini".text = (
    (import ./accounts/calcure.nix) {
      dirName = "${config.home.homeDirectory}/.calendar/personal";
      calendars = [
        "coupon"
        "dorm"
        "general"
        "lessons"
        "post-grad"
        "projects"
        "school"
        "school-schedule"
        "uk"
      ];
    }
  );

  programs.khal = {
    enable = true;
  };
  services.mbsync = {
    frequency = "*:0/1";
    enable = true;
    postExec = "${pkgs.notmuch}/bin/notmuch new";
  };
  programs.mbsync = {
    enable = true;
  };
  services.vdirsyncer.enable = true;
  programs.vdirsyncer.enable = true;
  programs.notmuch = {
    new.tags = [
      "unread"
      "inbox"
      "new"
    ];
    hooks.postNew = ''
      ${pkgs.notmuch}/bin/notmuch search --format json tag:new and tag:unread \
        | ${pkgs.jq}/bin/jq -r '.[] | "New email from \"\(.authors)\"\n\(.subject)"' \
        | while IFS= read -r title && IFS= read -r body; do
          ${pkgs.notify-desktop}/bin/notify-desktop "$title" "$body";
        done
      ${pkgs.notmuch}/bin/notmuch tag -new tag:new
    '';
    enable = true;
  };
  accounts = {
    email = {
      maildirBasePath = "${config.home.homeDirectory}/.mail";
      accounts = {
        personal = {
          notmuch.enable = true;
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
      basePath = "${config.home.homeDirectory}/.calendar";
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
