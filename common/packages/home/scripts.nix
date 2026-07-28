{
  custom.shell = {
    aliases = {
      d = ''("$@" > /dev/null 2>&1 &)'';
      rebuild = (builtins.readFile ./scripts/rebuild.sh);
    };
  };
}
