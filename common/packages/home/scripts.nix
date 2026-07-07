{
  custom.shell = {
    aliases = {
      d = ''("$@" > /dev/null 2>&1 &)'';
      temp = ''
        tempdir=$(mktemp -d "${"TMPDIR:-/tmp/"}$(basename $0).XXXXXXXXXXXX")
        cd $tempdir
      '';
      rebuild = (builtins.readFile ./scripts/rebuild.sh);
      venv = "python -m venv ./.venv";
    };
  };
}
