{
  username,
  pkgs,
  ...
}:
let
  writeAlias =
    a: builtins.attrValues (builtins.mapAttrs (key: value: (pkgs.writeShellScriptBin key value)) a);
  aliases = {
    # Baseline commands only
    jl = "sudo journalctl -xeu $@";
    jul = "journalctl --user -xeu $@";
    ss = "sudo systemctl status $@";
    sr = "sudo systemctl restart $@";
    sp = "sudo systemctl stop $@";
    sus = "systemctl --user status $@";
    sur = "systemctl --user restart $@";
    sup = "systemctl --user stop $@";
    update = "sudo nix-channel --update";
    hml = "journalctl -u home-manager-${username}.service -b";
    gc = "sudo nix-collect-garbage -d";
    gch = "nix-collect-garbage -d";
    dol = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d";
    km = ''echo "Copy the following into hardware-configuration.nix to get the OS to reboot."; nixos-generate-config --show-hardware-config'';
    currentboot = ''journalctl -o short-precise -k'';
    lastboot = ''journalctl -o short-precise -k -b -1'';
    printscript = ''cat $(whereis $1 | awk '{print $2}')'';
  };
in
{
  home.packages = (writeAlias aliases);
  programs.bash = {
    enable = true;
    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };
}
