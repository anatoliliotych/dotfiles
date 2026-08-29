{
  config,
  pkgs,
  ...
}:

{
  # Catppuccin Frappe colors for the custom prompt: exact hex values from
  # catppuccin/palette (red, text, teal, green), not guessed. True-color
  # %F{#hex} escapes replace the old $FG[256-index] approximations - more
  # accurate than quantizing to the nearest 256-color index.
  home.file.".config/oh-my-zsh/themes/onehalfdark.zsh-theme".text = ''
    #!/usr/bin/env zsh

    setopt promptsubst

    autoload -U add-zsh-hook
    RED='%F{#e78284}'
    WHITE='%F{#c6d0f5}'
    REPO_COLOR='%F{#81c8be}'
    GREEN='%F{#a6d189}'

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

  # catppuccin/zsh-syntax-highlighting's own Frappe theme file, fetched
  # verbatim rather than hand-porting ZSH_HIGHLIGHT_STYLES.
  home.file.".config/zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh".source =
    "${pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "zsh-syntax-highlighting";
      rev = "7926c3d3e17d26b3779851a2255b95ee650bd928";
      hash = "sha256-l6tztApzYpQ2/CiKuLBf8vI2imM6vPJuFdNDSEi7T/o=";
    }}/themes/catppuccin_frappe-zsh-syntax-highlighting.zsh";

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
      ls = "eza -a --icons --group-directories-first";
    };

    # fzf-tab colors: Catppuccin Frappe, values taken directly from
    # catppuccin/fzf's own frappe shell snippet (same --color= flag format)
    # rather than guessing a fresh palette. Fields with no match in that
    # snippet (bg, marker, spinner, border) are left out and fall back to
    # fzf's own defaults.
    initContent = ''
      zstyle ':fzf-tab:*' fzf-flags '--color=fg:#C6D0F5,fg+:#C6D0F5,bg+:#414559,hl:#E78284,hl+:#E78284,info:#CA9EE6,prompt:#CA9EE6,pointer:#F2D5CF,header:#E78284'
      source "${config.home.homeDirectory}/.config/zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh"
    '';
  };
}
