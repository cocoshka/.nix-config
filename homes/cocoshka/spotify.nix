{
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = {
    theme = spicePkgs.themes.comfy;
    colorScheme = "spotify";

    enabledSnippets = [
      ''
        .main-entityHeader-backgroundColor, .main-actionBarBackground-background {
          background-color: var(--decorative-subdued) !important;
        }

        .lyrics-lyrics-container {
          --lyrics-color-passed: var(--text-subdued) !important;
          --lyrics-color-active: var(--text-bright-accent) !important;
          --lyrics-color-inactive: var(--essential-subdued) !important;
          --lyrics-color-background: transparent !important;
          --lyrics-color-messaging: black !important;
        }
      ''
    ];

    enabledExtensions = with spicePkgs.extensions; [
      autoSkipVideo
      songStats
      betterGenres
      volumePercentage
    ];
  };
}
