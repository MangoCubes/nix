{
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://sh.skew.ch";
      search_mode = "fuzzy";
      enter_accept = true;
      filter_mode = "host";
      filter_mode_shell_up_key_binding = "session";
    };
  };
}
