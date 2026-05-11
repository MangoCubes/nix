{ lib, ... }:
{
  options.custom.shell.program = lib.mkOption {
    type = lib.types.str;
  };
}
