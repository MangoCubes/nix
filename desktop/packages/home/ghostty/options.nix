{ lib, ... }:
{
  options.custom.terminal = lib.mkOption {
    type = lib.types.function;
  };
}
