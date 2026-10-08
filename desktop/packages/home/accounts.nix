{
  inputs,
  pkgs,
  ...
}:
let
  checkKeyring = pkgs.writeShellScript "check-keyring-unlocked" (
    builtins.replaceStrings [ "@busctl@" ] [ "${pkgs.systemd}/bin/busctl" ] (
      builtins.readFile ./accounts/check-keyring.sh
    )
  );
in
{
  imports = [
    inputs.secrets.hm.accounts
  ];
  programs.msmtp.enable = true;
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
  systemd.user.services.mbsync = {
    Service = {
      ExecCondition = "${checkKeyring}";
    };
  };
  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/1";
  };
  programs.vdirsyncer.enable = true;
  systemd.user.services.vdirsyncer = {
    Service = {
      ExecCondition = "${checkKeyring}";
    };
  };
  programs.notmuch = {
    settings.new.tags = [
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
