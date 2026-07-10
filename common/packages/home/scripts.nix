{
  custom.shell = {
    aliases = {
      d = ''("$@" > /dev/null 2>&1 &)'';
      temp = ''
        tempdir=$(mktemp -d "${"TMPDIR:-/tmp/"}$(basename $0).XXXXXXXXXXXX")
        cd $tempdir
      '';
      rebuild = (builtins.readFile ./scripts/rebuild.sh);
    };
  };
  programs.zsh = {
    enable = true;
    initExtra = ''
      	venv() {
      		if [ -d "./.venv" ]; then
      			source ./.venv/bin/activate
      		else
      			python3 -m venv ./.venv && source ./.venv/bin/activate
      		fi
      	}
    '';
  };
}
