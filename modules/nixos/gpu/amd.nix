{
  config,
  lib,
  ...
}: let
  cfg = config.modules.gpu.amd;
in {
  options = {
    modules.gpu.amd = {
      enable = lib.mkEnableOption "enables amd gpu module";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = lib.mkDefault ["modesetting"];

    hardware.graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };

    hardware.amdgpu.initrd.enable = lib.mkDefault true;
  };
}
