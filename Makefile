update:
	-nix flake lock --update-input nixpkgs-upstream
	-nix flake lock --update-input nixpkgs-unstable

upgrade: update
	-nix flake lock --update-input nixpkgs
