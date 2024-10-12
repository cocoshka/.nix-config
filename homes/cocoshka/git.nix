{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Marcin Kokoszka";
    userEmail = "mcocoshka@gmail.com";

    extraConfig = {
      core = {
        autocrlf = false;
        filemode = false;
        ignorecase = false;
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSquash = true;
      };
    };
  };
}
