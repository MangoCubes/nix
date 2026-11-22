{
  pkgs,
  config,
  secrets,
  ...
}:
let
  wireproxyConfig = pkgs.writeText "wireproxy.conf" ''
    WGConfig = ${config.sops.secrets.browser-vpn.path}

    [Socks5]
    BindAddress = 127.0.0.1:25345
  '';
in
{
  imports = [ secrets.desktop.packages.home.browser-vpn ];
  systemd.user.services.browser-vpn = {
    Unit = {
      Description = "WireGuard tunnel of the VPN browser profile";
      After = [ "sops-nix.service" ];
    };
    Service = {
      ExecStart = "${pkgs.wireproxy}/bin/wireproxy -c ${wireproxyConfig}";
      Restart = "on-failure";
      RestartSec = "10";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
