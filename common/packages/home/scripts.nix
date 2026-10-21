{
  custom.shell = {
    aliases = {
      n = ''("$@" > /dev/null 2>&1 &)'';
      e = ''("$@" &)'';
      rebuild = (builtins.readFile ./scripts/rebuild.sh);
    };
  };
}
