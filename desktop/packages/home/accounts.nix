{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  checkKeyring = pkgs.writeShellApplication {
    name = "check-keyring";
    runtimeInputs = [ pkgs.systemd ];
    text = (builtins.readFile ./accounts/check-keyring.sh);
  };
in
{
  imports = [ inputs.secrets.desktop.packages.home.accounts ];
  programs.msmtp.enable = true;
  services.imapnotify = {
    enable = true;
    path = [ pkgs.libsecret ];
  };
  accounts.email.accounts.personal.imapnotify = {
    enable = true;
    boxes = [ "INBOX" ];
    onNotify = "${pkgs.systemd}/bin/systemctl --user start mbsync";
    extraConfig.passwordCmd = "${checkKeyring}/bin/check-keyring && ${lib.concatStringsSep " " config.accounts.email.accounts.personal.passwordCommand}";
  };
  services.mbsync = {
    frequency = "*:0/15";
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
      ExecCondition = "${checkKeyring}/bin/check-keyring";
    };
  };
  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/15";
  };
  programs.vdirsyncer.enable = true;
  systemd.user.services.vdirsyncer = {
    Service = {
      ExecCondition = "${checkKeyring}/bin/check-keyring";
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
          ${pkgs.libnotify}/bin/notify-send "$title" "$body";
        done
      ${pkgs.notmuch}/bin/notmuch tag -new tag:new
    '';
    enable = true;
  };
}
