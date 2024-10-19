update:
	-nix flake lock --update-input nixpkgs-upstream
	-nix flake lock --update-input nixpkgs-unstable

upgrade: update
	nix flake lock --update-input nixpkgs

repl:
	nix repl --show-trace --trace-verbose --expr "builtins.getFlake (toString ./.)"

test:
	sudo nixos-rebuild test --flake .

switch:
	sudo nixos-rebuild switch --flake .
