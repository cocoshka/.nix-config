{
  inputs,
  outputs,
  internal,
  pkgs,
  ...
}: {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  imports =
    [
      inputs.spicetify-nix.homeManagerModules.default
      outputs.homeModules
    ]
    ++ internal.listModules ./.;

  modules = {
    general.enable = true;
  };

  home.packages = with pkgs; [
    upstream.nixd
    alejandra
    bat
    btop
    jq
    fastfetch
    age
    amberol
    normcap # Screenshot OCR
    xsel # Required for normcap
    vlc
    anydesk
    clapper
  ];
}
