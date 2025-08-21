{ pkgs, ... }:
let
  genSys =
    {
      name,
      period,
      command,
      desc,
    }:
    let
      cmd = pkgs.writeShellScriptBin "${name}-cmd" command;
    in
    {
      systemd.user.timers."${name}" = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          # Start service after this time
          OnBootSec = period;
          # Run service periodically
          OnUnitActiveSec = period;
          Unit = "${name}.service";
        };
        Unit.Description = "Timer for ${name}.service";
      };
      # Restart Redlib and VPN if ratelimit is detected
      systemd.user.services."${name}" = {
        Unit.Description = desc;
        Service = {
          Type = "oneshot";
          ExecStart = "${cmd}/bin/${name}-cmd";
        };
      };
    };
in
{
  imports = [
    (genSys {
      name = "hourly";
      period = "1h";
      command = ''${pkgs.notify-desktop}/bin/notify-desktop "Hourly Reminder" "An hour has passed since the last notification." '';
      desc = "Run a set of commands every hour";
    })
  ];
}
