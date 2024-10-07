{
  inputs,
  outputs,
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
    };
  };
}
