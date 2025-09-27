{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.secrets.hm.accounts
  ];

  home.packages = [
    pkgs.jq
  ];
  programs.thunderbird = {
    enable = true;
    profiles = {
      main = {
        isDefault = true;
      };
    };
  };
  services.mbsync = {
    frequency = "*:0/1";
    enable = true;
    postExec = "${pkgs.notmuch}/bin/notmuch new";
  };
  programs.mbsync = {
    enable = true;
  };
  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/1";
  };
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
          thunderbird.enable = true;
          notmuch.enable = true;
          address = "admin@skew.ch";
          imap = {
            host = "mail.skew.ch";
            tls.enable = true;
            port = 993;
          };
          smtp = {
            host = "mail.skew.ch";
            tls.enable = true;
            port = 587;
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
        thunderbird.enable = true;
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
      };
    };
  };
}
