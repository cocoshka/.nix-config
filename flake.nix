{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-upstream.url = "github:nixos/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (nixpkgs) lib;

    flake-root = ./.;

    internal = import ./lib {inherit flake-root inputs outputs lib;};
  in {
    inherit internal;

    # Formatter for your nix files, available through 'nix fmt'
    formatter = internal.systems.for.all (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom packages, accessible through 'nix build', 'nix shell', etc
    packages = internal.systems.for.all (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Custom modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # Reusable modules, stuff that could be upstreamed into nixpkgs or home-manager
    nixosModules = import ./modules/nixos;
    homeModules = import ./modules/home;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = internal.forHosts lib.nixosSystem {
      "cocoshka@legion" = {
        inherit (inputs.home-manager.nixosModules) home-manager;
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#username@hostname'
    homeConfigurations = internal.forHomes home-manager.lib.homeManagerConfiguration {
      "cocoshka@rpi" = {};
    };
  };
}
