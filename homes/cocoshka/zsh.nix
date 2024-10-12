{pkgs, ...}: {
  modules = {
    programs.oh-my-posh = {
      enable = true;
      configFile = ./configs/oh-my-posh/config.yaml;
      symlink = true;
    };
  };

  programs.zsh = {
    enable = true;
    history = {
      append = true;
      ignoreAllDups = true;
      ignoreSpace = true;
    };
    plugins = with pkgs; [
      {
        name = "zsh-autosuggestions";
        src = zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-completions";
        src = zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "fzf-tab";
        src = zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "command-not-found"
        "colored-man-pages"
        "dirhistory"
        "jsontools"
      ];
    };
    initExtraBeforeCompInit = ''
      ZSH_DISABLE_COMPFIX=true
    '';
    initExtra = ''
      HISTDUP=erase

      setopt HIST_SAVE_NO_DUPS
      setopt HIST_FIND_NO_DUPS

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
    '';
  };

  programs.command-not-found.enable = true;
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
}
