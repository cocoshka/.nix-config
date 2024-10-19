{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = final.config.allowUnfree or false;
    };
  };

  upstream-packages = final: prev: {
    upstream = import inputs.nixpkgs-upstream {
      system = final.system;
      config.allowUnfree = final.config.allowUnfree or false;
    };
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    epsonscan2 = prev.epsonscan2.override {
      withNonFreePlugins = true;
      withGui = true;
    };

    dislocker = prev.dislocker.overrideAttrs (old: {
      version = "0.7.3-master";
      src = prev.fetchFromGitHub {
        owner = "aorimn";
        repo = "dislocker";
        rev = "3e7aea196eaa176c38296a9bc75c0201df0a3679";
        sha256 = "jKk+okSQJ54R17EiUk9NnjLxGi6RrwFrGFVi8ekckww=";
      };
      patches = [];
    });

    brave = prev.brave.override {
      commandLineArgs = "--disable-gpu-memory-buffer-video-frames";
    };
  };
}
