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
    BLUE=$FG[075]
    PURPLE=$FG[176]
    WHITE=$FG[188]
    REPO_COLOR=$FG[073]
    GREEN=$FG[114]

    PROMPT='%{$BLUE%}%U%m%u\
    %{$RED%}›\
    %{$PURPLE%}%U%~%u\
    %{$RED%}›\
    %{$REPO_COLOR%}$(repo_char)\
    %{$GREEN%}$(git_prompt_info)%f\
    %{$RED%}›\
    %{$WHITE%} '

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
    initContent = ''
      if token="$(op read 'op://Personal/DeepSeek API/credential' 2>/dev/null)"; then
        export ANTHROPIC_AUTH_TOKEN="$token"
      fi
    '';
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
      ls = "eza --icons --grid  --group-directories-first";
    };
  };
}
