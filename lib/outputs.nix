{
  flake-root,
  inputs,
  outputs,
  lib,
  internal,
  ...
}: let
  toNames = defaultName: name: let
    names = lib.split "@" name;
    username = lib.head names;
    hostname = lib.last names;

    hasBoth = (lib.length names) > 1;
  in
    if hasBoth
    then {
      inherit username hostname;
    }
    else {
      ${defaultName} = lib.head names;
    };
in rec {
  toHostUserNames = toNames "hostname";
  toUserHostNames = toNames "username";

  forHosts = configurator: configs:
    lib.mapAttrs' (
      name: attrs @ {
        specialArgs ? {},
        modules ? [],
        home-manager ? null,
        ...
      }: let
        names = toHostUserNames name;
        username = names.username or "";
        hostname = names.hostname;

        hardware-configuration = flake-root + /hosts/${hostname}/hardware-configuration.nix;
        configuration = flake-root + /hosts/${hostname}/configuration.nix;
        user-configuration = flake-root + /homes/${username}/default.nix;
        home-configuration = flake-root + /hosts/${hostname}/home.nix;

        args =
          {
            inherit flake-root inputs outputs internal;
          }
          // names
          // specialArgs;
      in
        lib.nameValuePair hostname
        (
          configurator (
            {
              specialArgs = args;

              modules =
                [
                  {
                    networking.hostName = lib.mkDefault hostname;
                  }
                ]
                ++ lib.optional (builtins.pathExists hardware-configuration) hardware-configuration
                ++ lib.optional (builtins.pathExists configuration) configuration
                ++ lib.optionals (home-manager != null) [
                  home-manager
                  {
                    home-manager.useGlobalPkgs = lib.mkDefault true;
                    home-manager.useUserPackages = lib.mkDefault true;
                    home-manager.extraSpecialArgs = args;
                    home-manager.backupFileExtension = lib.mkDefault "hm-backup";
                    home-manager.users = lib.mkIf (username != "") {
                      ${username} = {
                        imports =
                          lib.optional (builtins.pathExists user-configuration) user-configuration
                          ++ lib.optional (builtins.pathExists home-configuration) home-configuration;
                      };
                    };
                  }
                ]
                ++ modules;
            }
            // lib.removeAttrs attrs ["specialArgs" "modules" "home-manager"]
          )
        )
    )
    configs;

  forHomes = configurator: configs:
    lib.mapAttrs (
      name: attrs @ {
        extraSpecialArgs ? {},
        modules ? [],
        nixpkgs ? inputs.nixpkgs,
        ...
      }: let
        names = toUserHostNames name;
        username = names.username;
        hostname = names.hostname or "";

        user-configuration = flake-root + /homes/${username}/default.nix;
        home-configuration = flake-root + /hosts/${hostname}/home.nix;

        hostSystem =
          outputs.nixosConfigurations.${hostname}.pkgs.system
          or outputs.darwinConfigurations.${hostname}.pkgs.system
          or attrs.system
          or builtins.currentSystem;

        pkgs =
          if attrs ? pkgs
          then attrs.pkgs
          else nixpkgs.legacyPackages.${hostSystem};

        args =
          {
            inherit flake-root inputs outputs internal;
          }
          // names
          // extraSpecialArgs;
      in
        configurator (
          {
            inherit pkgs;

            extraSpecialArgs = args;

            modules =
              lib.optional (builtins.pathExists user-configuration) user-configuration
              ++ lib.optional (builtins.pathExists home-configuration) home-configuration
              ++ modules;
          }
          // lib.removeAttrs attrs ["extraSpecialArgs" "modules" "nixpkgs" "system" "pkgs"]
        )
    )
    configs;
}
