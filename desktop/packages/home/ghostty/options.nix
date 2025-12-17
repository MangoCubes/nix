{ lib, ... }:
{
  options.custom.terminal.program = lib.mkOption {
    type = lib.types.str;
  };
  options.custom.terminal.genCmd = lib.mkOption {
    type = lib.types.anything;
    default = { ... }: (builtins.abort "Function genCmd not defined!");
  };
  options.custom.terminal.genCmdList = lib.mkOption {
    type = lib.types.anything;
    default = { ... }: (builtins.abort "Function genCmdList not defined!");
  };
}
