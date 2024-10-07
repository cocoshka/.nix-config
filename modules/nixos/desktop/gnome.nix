{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.gnome;
in {
  options = {
    modules.desktop.gnome = {
      enable = lib.mkEnableOption "enables gnome desktop module";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;

    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  };
}
