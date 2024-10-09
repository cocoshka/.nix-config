{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  imports = [
    outputs.homeModules
  ];

  modules = {
    general.enable = true;
    programs.oh-my-posh = {
      enable = true;
      configFile = ./configs/oh-my-posh/config.yaml;
      symlink = true;
    };
  };

  fonts.fontconfig.enable = true;
  home.packages = [
    (pkgs.nerdfonts.override {fonts = ["FiraCode"];})
  ];

  programs.zsh = {
    enable = true;
    history = {
      append = true;
      ignoreAllDups = true;
      ignoreSpace = true;
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Marcin Kokoszka";
    userEmail = "mcocoshka@gmail.com";

    extraConfig = {
      core = {
        autocrlf = false;
        filemode = false;
        ignorecase = false;
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSquash = true;
      };
    };
  };

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
