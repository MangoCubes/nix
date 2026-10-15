{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.hibernation;
  swapFile = "/swapfile";
  # systemd-escape --path --suffix=swap ${swapFile}
  srvName = "swapfile.swap";
  isSwapActive = "${pkgs.gnugrep}/bin/grep -q '^${swapFile}' /proc/swaps";
in
{
  options.custom.hibernation.enable = lib.mkEnableOption "Enable hibernation";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      boot.initrd.systemd.enable = true;

      services.logind.settings.Login.HandleLidSwitch = lib.mkIf (
        config.custom.device.type == "laptop"
      ) "hibernate";

      swapDevices = [
        {
          device = swapFile;
          priority = 100;
        }
      ];

      # Based on https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/swap.nix
      systemd.services.prepare-swapfile = {
        description = "Prepare a swap file for hibernation";
        after = [ "systemd-modules-load.service" ];
        wantedBy = [ srvName ];
        # Starting swap triggers this service too
        requiredBy = [ srvName ];
        before = [
          # Ensure this service completes before swapping
          srvName
          # If shutdown gets called, stop this service
          "shutdown.target"
        ];
        conflicts = [ "shutdown.target" ];
        path = [ pkgs.util-linux ];
        script = ''
          if ${isSwapActive}; then
            exit 0
          fi

          mem_kib=$(sed -n '/^MemTotal:/s/[^0-9]//gp' /proc/meminfo)
          swap_bytes=$((mem_kib * 2048))
          current_bytes=$(stat -c %s "${swapFile}" 2>/dev/null || echo 0)
          if (( current_bytes < swap_bytes )); then
            mkswap --file --size "$swap_bytes" "${swapFile}"
          fi
        '';
        enableStrictShellChecks = true;

        unitConfig = {
          DefaultDependencies = false;
          # We need / to be available ofc
          RequiresMountsFor = [ (builtins.dirOf swapFile) ];
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          # Would make it 700
          UMask = "0077";
        };
        restartIfChanged = false;
      };
    })
    (lib.mkIf (!cfg.enable) {
      system.activationScripts.cleanupHibernation = ''
        if ${isSwapActive}; then
          ${pkgs.util-linux}/bin/swapoff "${swapFile}"
          ${pkgs.coreutils}/bin/rm -f "${swapFile}"
        fi
      '';
    })
  ];
}
