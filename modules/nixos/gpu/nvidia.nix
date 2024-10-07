{
  config,
  options,
  lib,
  ...
}: let
  cfg = config.modules.gpu.nvidia;
in {
  options = {
    modules.gpu.nvidia = {
      enable = lib.mkEnableOption "enables nvidia gpu module";
      hybrid = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      ddg = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hardware.nvidia.open = lib.mkDefault true;
      services.xserver.videoDrivers = lib.mkDefault ["nvidia"];

      hardware.nvidia = {
        modesetting.enable = lib.mkDefault true;
        powerManagement.enable = lib.mkDefault true;
      };
    }
    (lib.mkIf cfg.hybrid {
      hardware.nvidia.prime = {
        offload = {
          enable = lib.mkOverride 990 true;
          enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true;
        };
      };

      specialisation.game-mode.configuration = {
        hardware.nvidia.prime = {
          sync.enable = lib.mkForce true;
          offload = {
            enable = lib.mkForce false;
            enableOffloadCmd = lib.mkForce false;
          };
        };
      };

      specialisation.ddg.configuration = lib.mkIf cfg.ddg {
        system.nixos.tags = ["Dual-Direct-GFX-Mode"];
        services.xserver.videoDrivers = ["nvidia"];
        hardware =
          {
            nvidia.prime.sync.enable = lib.mkForce false;
            nvidia.prime.offload = {
              enable = lib.mkForce false;
              enableOffloadCmd = lib.mkForce false;
            };
          }
          // lib.optionalAttrs (options ? amdgpu.opencl.enable) {
            # introduced in https://github.com/NixOS/nixpkgs/pull/319865
            amdgpu.opencl.enable = lib.mkDefault false;
          };
      };
    })
  ]);
}
