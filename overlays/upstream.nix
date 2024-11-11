{inputs, ...}: let
  # When applied, the upstream nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.upstream'
  upstream-packages = final: prev: {
    upstream = import inputs.nixpkgs-upstream {
      system = final.system;
      config.allowUnfree = final.config.allowUnfree or false;
      overlays = [additions modifications];
    };
  };

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs/upstream.nix final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    foliate = prev.foliate.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/foliate \
          --prefix GSK_RENDERER : "ngl"
      '';
    });
  };
in
  upstream-packages
