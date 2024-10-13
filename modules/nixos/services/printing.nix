{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.printing;
in {
  options = {
    modules.services.printing = {
      enable = mkEnableOption "enables printing service module";
      share = mkEnableOption "enables printers sharing";
    };
  };

  config = mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing = mkMerge [
      {
        enable = true;
        drivers = with pkgs; [epson-escpr];
      }
      (mkIf cfg.share {
        listenAddresses = ["*:631"];
        allowFrom = ["all"];
        browsing = true;
        defaultShared = true;
        openFirewall = true;
      })
    ];

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;

      publish = mkIf cfg.share {
        enable = true;
        userServices = true;
      };
    };

    environment.systemPackages = with pkgs; [
      epsonscan2
    ];
  };
}
