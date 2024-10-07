{
  flake-root,
  lib,
  ...
} @ args: let
  include = file: import file (args // {inherit flake-root internal;});

  deepMergeAtrrs = attrs: lib.foldl lib.recursiveUpdate {} attrs;

  isModule = path: let
    name = builtins.baseNameOf path;
  in
    lib.pathIsDirectory path
    && lib.pathExists (path + "/default.nix")
    || lib.pathIsRegularFile path && name != "default.nix" && !(lib.hasPrefix "_" name) && lib.hasSuffix ".nix" name;

  listModules = dir:
    lib.flatten (lib.mapAttrsToList (name: type: let
      path = dir + "/${name}";
    in (lib.optional (isModule path) path)) (builtins.readDir dir));

  listModulesRec = dir:
    lib.flatten (lib.mapAttrsToList (
      name: type: let
        path = dir + "/${name}";
        isDir = type == "directory";
      in
        (lib.optional (isModule path) path)
        ++ (lib.optionals isDir (listModulesRec path))
    ) (builtins.readDir dir));

  internal = deepMergeAtrrs ([
      {
        inherit deepMergeAtrrs;
        inherit isModule listModules listModulesRec;
      }
    ]
    ++ (lib.map include (listModulesRec ./.)));
in
  internal
