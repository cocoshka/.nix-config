{
  options,
  config,
  lib,
  ...
} @ args: let
  cfg = config.modules.user;
  username = args.username or cfg.name or "";
  enabled = username != "";
in {
  options = {
    modules.user = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = {
    assertions = [
      {
        assertion = enabled && (lib.length (lib.attrNames cfg)) > 0;
        message = "No username argument or config.modules.user.name provided!";
      }
    ];

    modules.user = {
      isNormalUser = true;
      description = lib.mkDefault (cfg.name or args.username);
      extraGroups = ["wheel"];
      initialPassword = "nixos";
    };

    users.users = lib.mkIf enabled {
      ${username} = lib.mkAliasDefinitions options.modules.user;
    };
  };
}
