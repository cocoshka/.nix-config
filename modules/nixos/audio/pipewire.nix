{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.audio.pipewire;
in {
  options = {
    modules.audio.pipewire = {
      enable = mkEnableOption "enables pipewire audio module";
      virtualDevices = mkOption {
        type = types.listOf types.attrs;
        default = [];
      };
    };
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;

      extraConfig.pipewire."91-null-sinks" = {
        "context.objects" =
          [
            {
              # A default dummy driver. This handles nodes marked with the "node.always-driver"
              # properyty when no other driver is currently active. JACK clients need this.
              factory = "spa-node-factory";
              args = {
                "factory.name" = "support.node.driver";
                "node.name" = "Dummy-Driver";
                "priority.driver" = 8000;
              };
            }
          ]
          ++ lib.map (device:
            if device ? factory
            then device
            else {
              factory = "adapter";
              args =
                {
                  "factory.name" = "support.null-audio-sink";
                }
                // device;
            })
          cfg.virtualDevices;
      };
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      helvum
    ];
  };
}
