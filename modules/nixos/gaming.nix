{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.modules.gaming;
in {
  options = {
    modules.gaming = {
      enable = lib.mkEnableOption "enables gaming module";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.user = {
      extraGroups = ["gamemode"];
    };

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraPackages = with pkgs; [
        gamemode
        gamescope
        mangohud
      ];
    };

    programs.gamemode.enable = true;
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--steam"
        "--expose-wayland"
        "--rt"
        "--force-grab-cursor"
        "--grab"
      ];
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup
      lutris
      heroic
      bottles
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${username}/.steam/root/compatibilitytools.d";
    };

    programs.nix-ld.libraries = with pkgs; [
      gamemode
    ];
  };
}
