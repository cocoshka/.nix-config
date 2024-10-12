{
  inputs,
  config,
  lib,
  ...
}: {
  config = {
    lib.file.mkMutableSymlink = path: config.lib.file.mkOutOfStoreSymlink (config.home.homeDirectory + "/.nix-config/" + lib.removePrefix (toString inputs.self) (toString path));
  };
}
