{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.hardware.tlp;
in {
  options = {
    modules.hardware.tlp = {
      enable = mkEnableOption "enables tlp hardware module";
    };
  };

  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = false;
    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # Not supported for amd-pstate driver on Linux kernel lower than 6.11
        # Enable when kernel is upgraded (current is 6.6)
        # CPU_BOOST_ON_AC = 1;
        # CPU_BOOST_ON_BAT = 0;

        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
