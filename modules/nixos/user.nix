{
  lib,
  username ? "",
  ...
}: let
  enabled = username != "";
in {
  imports = lib.optionals enabled [
    (lib.mkAliasOptionModule ["modules" "user"] ["users" "users" username])
  ];

  config = lib.mkIf enabled {
    modules.user = {
      isNormalUser = true;
      description = lib.mkDefault username;
      extraGroups = ["wheel"];
      initialPassword = "nixos";
    };
  };
}
