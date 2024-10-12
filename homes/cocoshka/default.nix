{
  outputs,
  internal,
  pkgs,
  ...
}: {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  imports =
    [
      outputs.homeModules
    ]
    ++ internal.listModules ./.;

  modules = {
    general.enable = true;
  };

  home.packages = with pkgs; [
    bat
    btop
    jq
    fastfetch
  ];
}
