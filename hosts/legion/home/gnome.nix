{...}: {
  dconf.settings = {
    "org/gnome/mutter" = {
      # Broken, see https://gitlab.gnome.org/GNOME/mutter/-/issues/3509
      # experimental-features = ["scale-monitor-framebuffer"];
    };
  };
}
