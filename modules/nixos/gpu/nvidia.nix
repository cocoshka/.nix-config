{
  config,
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
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hardware.nvidia = {
        open = lib.mkDefault false;
        modesetting.enable = lib.mkDefault true;
        powerManagement.enable = lib.mkDefault false;
      };
      services.xserver.videoDrivers = lib.mkDefault ["nvidia"];
      environment.variables = {
        # Hardware cursors are currently broken on nvidia
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    }
    (lib.mkIf cfg.hybrid {
      hardware.nvidia = {
        prime.sync.enable = lib.mkOverride 990 true;
      };

      specialisation = {
        on-the-go.configuration = {
          system.nixos.tags = ["on-the-go"];
          hardware.nvidia.prime = {
            sync.enable = lib.mkForce false;
            offload = {
              enable = lib.mkOverride 990 true;
              enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true;
            };
          };
        };

        ddg.configuration = {
          system.nixos.tags = ["Dual-Direct-GFX-Mode"];
          hardware.nvidia.prime = {
            sync.enable = lib.mkForce false;
            offload = {
              enable = lib.mkForce false;
              enableOffloadCmd = lib.mkForce false;
            };
          };
        };
      };
    })
    (lib.mkIf (cfg.hybrid && config.modules.gpu.amd.enable) {
      boot.kernelModules = lib.mkIf config.modules.gpu.amd.enable ["amdgpu"];
      hardware.amdgpu.initrd.enable = false;
    })
  ]);
}
