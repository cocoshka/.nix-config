{
  config,
  lib,
  ...
}: let
  cfg = config.modules.general;
in {
  options = {
    modules.general = {
      enable = lib.mkEnableOption "enables general module";
    };
  };

  config = lib.mkIf cfg.enable {
    modules = {
      best-practices.enable = true;
      locale = {
        enable = lib.mkDefault true;
        formats = lib.mkDefault "pl_PL.UTF-8";
      };
    };

    time.timeZone = lib.mkDefault "Europe/Warsaw";
    time.hardwareClockInLocalTime = true;

    services.xserver.xkb = lib.mkDefault {
      layout = "pl";
      variant = "";
    };

    console.keyMap = lib.mkDefault "pl2";

    services.openssh.enable = true;
  };
}
