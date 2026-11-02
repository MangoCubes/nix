{ config, ... }: {
  custom.shell = {
    aliases = {
      n = ''("$@" > /dev/null 2>&1 &)'';
      e = ''("$@" &)'';
      rebuild = (
        builtins.replaceStrings [ "@keyLocation@" ] [ config.custom.keys.gitea ] (
          builtins.readFile ./scripts/rebuild.sh
        )
      );
    };
  };
}
