{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  modules = {};

  home.packages = with pkgs; [
    brave
    vesktop
    vscode
    fastfetch

    (makeAutostartItem {
      name = "vesktop";
      package = vesktop;
    })
  ];

  programs.spicetify.enable = true;
}
