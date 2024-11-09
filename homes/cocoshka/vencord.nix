{config, ...}: {
  modules.programs.vencord = {
    enable = true;
    xdgName = "vesktop";
    sourceDir = config.lib.file.mkMutableSymlink ./configs/vencord;
  };
}
