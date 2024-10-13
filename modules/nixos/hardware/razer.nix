{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.razer;
in {
  options = {
    modules.hardware.razer = {
      enable = mkEnableOption "enables razer hardware module";
    };
  };

  config = mkIf cfg.enable {
    modules = {
      user = {
        extraGroups = ["openrazer"];
      };
    };

    hardware.openrazer.enable = true;

    environment.systemPackages = with pkgs; [
      openrazer-daemon
      polychromatic
    ];
  };
}
