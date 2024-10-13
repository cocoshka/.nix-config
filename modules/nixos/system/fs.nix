{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.fs;
in {
  options = {
    modules.system.fs = {
      enable = mkEnableOption "enables system fs module";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      exfat #ExFAT drives
      ntfs3g # Windows drives
      hfsprogs # MacOS drives
      cryptsetup # for Luks drives
      dislocker # BitLocker encrypted file systems
      libguestfs # Virtual drives
    ];

    services.udisks2.enable = true;
  };
}
