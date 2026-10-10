{ username, ... }: {
  programs.ydotool = {
    enable = true;
    group = "ydotool";
  };
  users.groups = {
    ydotool = { };
  };
  users.users."${username}".extraGroups = [ "ydotool" ];
}
