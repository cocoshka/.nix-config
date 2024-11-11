{inputs, ...}: let
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = final.config.allowUnfree or false;
      overlays = [additions modifications];
    };
  };

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs/unstable.nix final.pkgs;

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
in
  unstable-packages
