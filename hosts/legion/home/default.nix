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
    obsidian
    caprine
    bitwarden-desktop

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
