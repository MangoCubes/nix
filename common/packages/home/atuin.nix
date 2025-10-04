{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.secrets.hm.atuin
  ];
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://sh.skew.ch";
      search_mode = "fuzzy";
      enter_accept = true;
      filter_mode = "global";
      filter_mode_shell_up_key_binding = "session";
      session_path = "${config.home.homeDirectory}/.config/sops-nix/secrets/atuin/session";
      key_path = "${config.home.homeDirectory}/.config/sops-nix/secrets/atuin/key";
      keymap_mode = "vim-insert";
      inline_height = 10;
    };
  };
}
