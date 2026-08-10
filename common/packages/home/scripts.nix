{
  custom.shell = {
    aliases = {
      d = ''("$@" &)'';
      rebuild = (builtins.readFile ./scripts/rebuild.sh);
    };
  };
}
