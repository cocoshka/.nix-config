{
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  programs.spicetify = {
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "frappe";

    enabledExtensions = with spicePkgs.extensions; [
      # adblock
      autoSkipVideo
      bookmark
      fullAppDisplay
      shuffle
      trashbin

      goToSong
      songStats
      betterGenres
      hidePodcasts
      volumePercentage
    ];

    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      # marketplace
      historyInSidebar
    ];
  };
}
