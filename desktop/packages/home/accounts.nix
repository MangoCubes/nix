{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.secrets.hm.accounts
    inputs.secrets.hm.accountSecrets
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
    # Delete ~/.mail/personal (keep ~/.mail/personal directory itself) if this error happens:
    # Error: channel personal: far side box ___ cannot be opened anymore.
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
}
