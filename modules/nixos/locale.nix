{
  config,
  lib,
  ...
}: let
  cfg = config.modules.locale;
in {
  options = {
    modules.locale = {
      enable = lib.mkEnableOption "enables locale module";
      language = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
      };
      formats = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.defaultLocale = lib.mkDefault cfg.language;

    i18n.extraLocaleSettings = lib.mkDefault {
      LC_ADDRESS = cfg.formats;
      LC_IDENTIFICATION = cfg.formats;
      LC_MEASUREMENT = cfg.formats;
      LC_MONETARY = cfg.formats;
      LC_NAME = cfg.formats;
      LC_NUMERIC = cfg.formats;
      LC_PAPER = cfg.formats;
      LC_TELEPHONE = cfg.formats;
      LC_TIME = cfg.formats;
    };
  };
}
