{
  inputs,
  config,
  lib,
  ...
} @ attrs: let
  cfg = config.modules.gpu.amd;
in {
  options = {
    modules.gpu.amd = {
      enable = lib.mkEnableOption "enables amd gpu module";
    };
  };

  config = lib.mkIf cfg.enable ((import inputs.nixos-hardware.nixosModules.common-gpu-amd attrs).config);
}
