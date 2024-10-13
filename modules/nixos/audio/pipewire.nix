{
  config,
  lib,
  ...
}: let
  cfg = config.modules.audio.pipewire;
in {
  options = {
    modules.audio.pipewire = {
      enable = lib.mkEnableOption "enables pipewire audio module";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
}
