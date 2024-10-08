{
  config,
  lib,
  ...
}: let
  cfg = config.modules.virtualisation.docker;
in {
  options = {
    modules.virtualisation.docker = {
      enable = lib.mkEnableOption "enables docker virtualisation module";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.user = {
      extraGroups = ["docker"];
    };

    virtualisation.docker.enable = true;
  };
}
