{ unfreeUnstable, inputs, ... }:
let
  cred = inputs.secrets.hm.factorio;
  f = unfreeUnstable.factorio.override {
    versionsJson = ./factorio/factorio.json;
    username = cred.username;
    token = cred.token;
  };
in
{
  home.packages = [ f ];
}
