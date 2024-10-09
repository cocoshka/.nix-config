{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.oh-my-posh;

  fileName = builtins.baseNameOf cfg.configFile;
in {
  options = {
    modules.programs.oh-my-posh = {
      enable = lib.mkEnableOption "enables oh-my-posh module";
      package = lib.mkPackageOption pkgs "oh-my-posh" {};
      configFile = lib.mkOption {
        type = lib.types.path;
      };
      symlink = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    xdg.configFile."oh-my-posh/configs/${fileName}" = {
      source =
        if cfg.symlink
        then config.lib.file.mkMutableSymlink cfg.configFile
        else cfg.configFile;
    };

    programs.zsh = {
      initExtra = ''
        eval "$(${cfg.package}/bin/oh-my-posh init zsh --config ${config.xdg.configHome}/oh-my-posh/configs/${fileName})"
      '';
    };
  };
}
