{...}: {
  home.shellAliases = {
    dotfiles = "GIT_WORK_TREE=~ GIT_DIR=$GIT_WORK_TREE/.dotfiles";
    suroot = "sudo -E -s";
  };
}
