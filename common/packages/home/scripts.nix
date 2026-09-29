{ config, ... }: {
  custom.shell = {
    aliases = {
      d = ''("$@" > /dev/null 2>&1 &)'';
      e = ''("$@" &)'';
      cdt = "cd ${config.home.homeDirectory}/Temp";
      rebuild = (builtins.readFile ./scripts/rebuild.sh);
    };
  };
}
