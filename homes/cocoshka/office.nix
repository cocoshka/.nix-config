{pkgs, ...}: {
  home.packages = with pkgs; [
    onlyoffice-desktopeditors
    upstream.obsidian
  ];
}
