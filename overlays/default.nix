{...} @ args: {
  # These ones brings the unstable and upstream packages from the nixpkgs repository
  unstable-packages = import ./unstable.nix args;
  upstream-packages = import ./upstream.nix args;

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
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
