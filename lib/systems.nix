{lib, ...}: {
  # Supported systems
  systems = let
    linux = ["aarch64-linux" "x86_64-linux" "i686-linux"];
    darwin = ["aarch64-darwin" "x86_64-darwin"];
    all = linux ++ darwin;

    for = {
      linux = lib.genAttrs linux;
      darwin = lib.genAttrs darwin;
      all = lib.genAttrs all;
    };
  in
    {
      inherit linux darwin all for;
    }
    // for.all (system: system);
}
