{
  outputs,
  options,
  config,
  lib,
  username,
  ...
}: let
  cfg = config.modules.best-practices;
in {
  options = {
    modules.best-practices = {
      enable = lib.mkEnableOption "enabels best practices module";
    };
  };

  config = lib.mkIf cfg.enable {
    # Applies if not using global packages (home-manager.useGlobalPkgs == true => options.nixpkgs.config.visible == false)
    # when using home-manager as NixOS module (config.submoduleSupport.enable == true)
    nixpkgs = lib.mkIf (options.nixpkgs.config.visible or true) {
      config = {
        allowUnfree = lib.mkDefault true;
      };

      overlays = [
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages
      ];
    };

    # Let Home Manager install and manage itself (disabled automatically when used as NixOS module)
    programs.home-manager.enable = lib.mkDefault true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = lib.mkDefault "sd-switch";

    home = {
      username = lib.mkDefault username;
      homeDirectory = lib.mkDefault "/home/${username}";
    };
  };
}
