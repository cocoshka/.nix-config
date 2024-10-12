{pkgs, ...}: {
  modules = {
    virtualisation.qemu.enable = true;
  };

  home.packages = with pkgs; [
    brave
    vesktop
    vscode
    ffmpeg
    obsidian
    caprine

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
