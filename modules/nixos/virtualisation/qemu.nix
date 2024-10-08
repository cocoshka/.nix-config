{
  config,
  lib,
  pkgs,
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
    modules.user = {
      extraGroups = ["kvm" "libvirtd" "input"];
    };

    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
      options kvm ignore_msrs=1 report_ignored_msrs=0
    '';

    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      dmg2img
    ];
  };
}
