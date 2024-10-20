{
  inputs,
  outputs,
  config,
  lib,
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
    nix = let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = lib.mkDefault "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        # Optimize storage
        # You can also manually optimize the store via:
        #    nix-store --optimise
        auto-optimise-store = lib.mkDefault true;
      };
      # Opinionated: disable channels
      channel.enable = lib.mkDefault false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      # Perform garbage collection weekly to maintain low disk usage
      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 1w";
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = lib.mkDefault true;
      };

      overlays = [
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages
        outputs.overlays.upstream-packages
      ];
    };

    # Limit the number of generations to keep
    boot.loader = {
      systemd-boot.configurationLimit = lib.mkDefault 10;
      grub.configurationLimit = lib.mkDefault 10;
    };

    services.openssh = {
      settings = {
        # Opinionated: forbid root login through SSH.
        PermitRootLogin = lib.mkDefault "no";
        # Opinionated: use keys only.
        PasswordAuthentication = lib.mkDefault false;
      };
    };

    # Fix for NixOS unable to run dynamically linked executables intended for generic linux environments out of the box.
    # https://nix.dev/permalink/stub-ld
    programs.nix-ld.enable = true;
  };
}
