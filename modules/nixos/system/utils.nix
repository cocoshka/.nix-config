{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.utils;
in {
  options = {
    modules.system.utils = {
      enable = mkEnableOption "enables system utils module";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      curl
      wget
      pciutils
      sbctl
      usbutils
      hwinfo
    ];
  };
}
