{
  config,
  pkgs,
  ...
}:

{
  home.file.".config/oh-my-zsh/themes/onehalfdark.zsh-theme".text = ''
    #!/usr/bin/env zsh

    setopt promptsubst

    autoload -U add-zsh-hook
    RED=$FG[168]
    WHITE=$FG[188]
    REPO_COLOR=$FG[073]
    GREEN=$FG[114]

    # Host and path live in the tmux status line (host:dir on the left);
    # the prompt keeps only the repo status and git branch.
    PROMPT='%{$REPO_COLOR%}$(repo_char) %{$GREEN%}$(git_prompt_info)%f %{$RED%}›%{$WHITE%} '

    function repo_char {
      git branch >/dev/null 2>/dev/null && echo '±' && return
      echo '○'
    }

    ZSH_THEME_GIT_PROMPT_PREFIX=":("
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$GREEN%})"
    ZSH_THEME_GIT_PROMPT_DIRTY=" %{$RED%}✘"
    ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GREEN%}✔"
  '';

  programs.zsh = {
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
    enable = true;
    autosuggestion = {
      enable = true;
    };
    history = {
      # Holds the merged multi-year history (20k+ lines imported from
      # Downloads/.zsh_history); default 10000 would trim it.
      size = 50000;
      save = 50000;
    };
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "vi-mode"
        "autojump"
      ];
      theme = "onehalfdark";
      custom = "${config.home.homeDirectory}/.config/oh-my-zsh";
    };

    shellAliases = {
      vim = "nvim";
      ls = "eza --icons --group-directories-first";
    };
  };
}
