{
  networking.firewall = {
    enable = true;
    # Starcraft 2 ports
    # https://us.forums.blizzard.com/en/sc2/t/how-to-put-in-ports-number-for-blizzard-games/7533/2
    #       	TCP PORTS 	UDP PORTS
    # Blizzard Battle.net desktop app 	80, 443, 1119 	80, 443, 1119
    # Blizzard Voice Chat 	80, 443, 1119 	3478-3479, 5060, 5062, 6250, 12000-64000
    # Blizzard Downloader 	1119, 1120, 3724, 4000, 6112, 6113, 6114 	1119, 1120, 3724, 4000, 6112, 6113, 6114
    # Diablo 	6112-6119 	6112-6119
    # Diablo II 	6112 and 4000 	None
    # Diablo III 	80, 1119 	1119, 6120
    # Hearthstone 	1119, 3724 	1119, 3724
    # Heroes of the Storm 	80, 443, 1119-1120, 3724, 6113 	80, 1119-1120, 3478-3479, 3724, 5060, 5062, 6113, 6250, 12000-64000
    # Overwatch 	1119, 3724, 6113, 80 	3478-3479, 5060, 5062, 6250, 12000-64000
    # StarCraft 	6112 	6112
    # StarCraft II 	1119, 6113, 1120, 80, 3724 	1119, 6113, 1120, 80, 3724
    # Warcraft II Battle.net Edition 	6112-6119 	6112-6119
    # Warcraft III 	6112 (Default) and 6113-6119 	None
    # World of Warcraft 	3724, 1119, 6012 	3724, 1119, 6012
    # Call of Duty: Black Ops 4
    #
    # PC: 3074, 27014-27050
    # PlayStation 4: 80, 443, 1935, 3478-3480
    # XBox One: 53, 80, 3074
    # 	PC: 3478, 4379-4380, 27000-27031, 27036
    # PlayStation 4: 3478-3479
    # XBox One: 53, 88, 500, 3074, 3075, 3544, 4500
    # Call of Duty: Modern Warfare 	PC: 3074, 27014-27050
    # PlayStation 4: 80, 443, 1935, 3478-3480
    # XBox One: 53, 80, 3074 	PC: 3074, 3478, 4379-4380, 27000-27031, 27036
    # PlayStation 4: 3074, 3478-3479
    # XBox One: 53, 88, 500, 3074, 3075, 3544, 4500
    allowedTCPPorts = [
      80
      443
      1119
      1120
      3074
      3724
      4000
    ];
    allowedTCPPortRanges = [
      {
        from = 6112;
        to = 6120;
      }
      {
        from = 27014;
        to = 27050;
      }
    ];
    allowedUDPPorts = [
      80
      443
      1119
      1120
      3478
      3479
      3724
      4000
      4379
      4380
      5060
      5062
      6250
      27036
    ];
    allowedUDPPortRanges = [
      {
        from = 6112;
        to = 6119;
      }
      {
        from = 27000;
        to = 27031;
      }
      {
        from = 12000;
        to = 64000;
      }
    ];
  };
}
