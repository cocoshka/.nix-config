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

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

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
        pip-on-top
        # Gnome dash-to-dock extension crashes Gnome on suspend
        # (gnomeExtensions.dash-to-dock.override {
        #   version = "99";
        #   metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIkEgZG9jayBmb3IgdGhlIEdub21lIFNoZWxsLiBUaGlzIGV4dGVuc2lvbiBtb3ZlcyB0aGUgZGFzaCBvdXQgb2YgdGhlIG92ZXJ2aWV3IHRyYW5zZm9ybWluZyBpdCBpbiBhIGRvY2sgZm9yIGFuIGVhc2llciBsYXVuY2hpbmcgb2YgYXBwbGljYXRpb25zIGFuZCBhIGZhc3RlciBzd2l0Y2hpbmcgYmV0d2VlbiB3aW5kb3dzIGFuZCBkZXNrdG9wcy4gU2lkZSBhbmQgYm90dG9tIHBsYWNlbWVudCBvcHRpb25zIGFyZSBhdmFpbGFibGUuIiwKICAiZ2V0dGV4dC1kb21haW4iOiAiZGFzaHRvZG9jayIsCiAgIm5hbWUiOiAiRGFzaCB0byBEb2NrIiwKICAib3JpZ2luYWwtYXV0aG9yIjogIm1pY3hneEBnbWFpbC5jb20iLAogICJzaGVsbC12ZXJzaW9uIjogWwogICAgIjQ1IiwKICAgICI0NiIsCiAgICAiNDciCiAgXSwKICAidXJsIjogImh0dHBzOi8vbWljaGVsZWcuZ2l0aHViLmlvL2Rhc2gtdG8tZG9jay8iLAogICJ1dWlkIjogImRhc2gtdG8tZG9ja0BtaWN4Z3guZ21haWwuY29tIiwKICAidmVyc2lvbiI6IDk5Cn0=";
        #   sha256 = "sha256-ynxrsCUiENJ/X3sSuCiHWh0BDB6Dcahld0qMszgofKM=";
        # })
      ]);
  };
}
