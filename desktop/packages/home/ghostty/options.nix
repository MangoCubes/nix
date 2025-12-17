{ lib, ... }:
{
  options.custom.terminal.program = lib.mkOption {
    type = lib.types.str;
  };
  options.custom.terminal.genCmd = lib.mkOption {
    type = lib.types.anything;
  };
}
