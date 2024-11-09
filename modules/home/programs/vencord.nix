{
  config,
  lib,
  ...
}: let
  cfg = config.modules.programs.vencord;
in {
  options = {
    modules.programs.vencord = {
      enable = lib.mkEnableOption "enables vencord module";
      xdgName = lib.mkOption {
        type = lib.types.str;
        default = "discord";
      };
      sourceDir = lib.mkOption {
        type = lib.types.path;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."${cfg.xdgName}/settings" = {
      source = cfg.sourceDir;
    };
  };
}
