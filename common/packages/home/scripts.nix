{
  custom.shell = {
    aliases = {
      d = ''("$@" > /dev/null 2>&1 &)'';
      e = ''("$@" &)'';
      rebuild = (builtins.readFile ./scripts/rebuild.sh);
    };
  };
}
