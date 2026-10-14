{ pkgs, ... }:
let
  mergepasswords = pkgs.writeShellScriptBin "mergepasswords" (
    builtins.readFile ./keepassxc/mergepasswords.sh
  );
in
{
  programs.keepassxc = {
    enable = true;
    settings = {
      General = {
        AutoGeneratePasswordForNewEntries = true;
        BackupBeforeSave = true;
        UseAtomicSaves = false;
      };
      Browser.Enabled = true;
      FdoSecrets = {
        ConfirmAccessItem = false;
        ConfirmDeleteItem = false;
        Enabled = true;
        ShowNotification = false;
        UnlockBeforeSearch = false;
      };
      GUI = {
        ApplicationTheme = "dark";
        ColorPasswords = true;
        CompactMode = true;
        ShowExpiredEntriesOnDatabaseUnlockOffsetDays = 30;
        ShowTrayIcon = true;
        TrayIconAppearance = "monochrome-light";
      };
      PasswordGenerator = {
        AdvancedMode = true;
        Length = 32;
        WordCount = 5;
      };
      SSHAgent.Enabled = true;
      Security = {
        IconDownloadFallback = true;
        LockDatabaseIdle = false;
      };
    };
  };
  home.packages = [
    pkgs.libsecret
    mergepasswords
  ];
}
