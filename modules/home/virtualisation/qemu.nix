{
  config,
  lib,
  ...
}: let
  cfg = config.modules.virtualisation.qemu;
in {
  options = {
    modules.virtualisation.qemu = {
      enable = lib.mkEnableOption "enables QEMU virtualisation module";
    };
  };

  config = lib.mkIf cfg.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
