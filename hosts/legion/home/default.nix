{
  pkgs,
  internal,
  ...
}: {
  imports = internal.listModules ./.;

  modules = {
    virtualisation.qemu.enable = true;
  };

  home.packages = with pkgs; [
    brave
    vesktop
    ffmpeg
    caprine
    bitwarden-desktop
    qbittorrent

    (makeAutostartItem {
      name = "vesktop";
      package = vesktop;
    })
    (makeAutostartItem {
      name = "caprine";
      package = caprine;
    })
  ];

  programs.spicetify.enable = true;
}
