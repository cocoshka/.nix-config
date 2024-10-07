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
  ];

  programs.spicetify.enable = true;
}
