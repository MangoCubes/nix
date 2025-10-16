{ unfreeUnstable, inputs, ... }:
let
  cred = inputs.secrets.hm.factorio;
  f = unfreeUnstable.factorio-space-age.override {
    username = cred.username;
    token = cred.token;
  };
in
{
  home.packages = [ f ];
}
