{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.zsh;
in {
  options = {
    modules.shell.zsh = {
      enable = mkEnableOption "enables shell zsh module";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;

    users.defaultUserShell = pkgs.zsh;
  };
}
