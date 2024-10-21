{
  config,
  lib,
  pkgs,
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

    environment.gnome.excludePackages = with pkgs; [
      gnome-contacts
      gnome-music
      gnome-weather
      gnome-photos
      gnome-tour
      gnome-connections
      epiphany
      totem
      geary
      yelp
    ];

    services.xserver.excludePackages = with pkgs; [
      xterm
    ];

    environment.systemPackages = with pkgs;
      [
        gnome-tweaks
      ]
      ++ (with pkgs.gnomeExtensions; [
        dash-to-dock
        pip-on-top
      ]);
  };
}
