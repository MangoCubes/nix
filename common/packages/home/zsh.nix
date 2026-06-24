{
  username,
  pkgs,
  config,
  ...
}:
let
  writeAlias =
    a: builtins.attrValues (builtins.mapAttrs (key: value: (pkgs.writeShellScriptBin key value)) a);
in
{
  imports = [ ./zsh/options.nix ];
  custom.shell = {
    program = "zsh";
    aliases = {
      # Baseline commands only
      jl = "sudo journalctl --follow -xeu $@";
      jul = "journalctl --user --follow -xeu $@";
      ss = "sudo systemctl status $@";
      sr = "sudo systemctl restart $@";
      sp = "sudo systemctl stop $@";
      sus = "systemctl --user status $@";
      sur = "systemctl --user restart $@";
      sup = "systemctl --user stop $@";
      hml = "journalctl -u home-manager-${username}.service -b";
      km = ''echo "Copy the following into hardware-configuration.nix to get the OS to reboot."; nixos-generate-config --show-hardware-config'';
      currentboot = "journalctl -o short-precise -k";
      lastboot = "journalctl -o short-precise -k -b -1";
      printscript = "cat $(whereis $1 | awk '{print $2}')";
      shell = "${pkgs.zsh}/bin/zsh";
      o = "xdg-open $@";
    };
  };
  programs.zsh = {
    enable = true;
    initContent = ''
      PROMPT='%F{cyan}╭─%f[%F{blue}%D{%Y-%m-%d} %*%f]─[%F{green}%n%f%F{cyan}@%f%F{magenta}%m%f]─[%F{yellow}%B%~%b%f]%(1j.─[%F{cyan}⚙ %j%f].)%(!.─[%B%F{red}⚠ ROOT%f%b].)
      %F{cyan}╰─%f%(?.%F{green}[0].%F{red}[%?])%f %F{magenta}>%F{cyan}>%F{yellow}>%f ' '';
  };
  home = {
    packages = (writeAlias config.custom.shell.aliases);
    shell = {
      enableZshIntegration = true;
    };
  };
}
