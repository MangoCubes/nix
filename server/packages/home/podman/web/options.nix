{ lib, ... }:

{
  options.custom.web = {
    content = lib.mkOption {
      type = (lib.types.attrsOf lib.types.str);
      default = { };
    };
    # settings = lib.mkOption {
    #   type = (lib.types.attrsOf lib.types.str);
    #   default = { };
    # };
  };
}
