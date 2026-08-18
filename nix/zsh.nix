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
    initContent = ''
      _token_cache="$HOME/.cache/anthropic-token"
      _token_ttl=86400
      if [[ -f "$_token_cache" ]] && (( $(($(date +%s) - $(stat -f %m "$_token_cache"))) < _token_ttl )); then
        # Fresh cache: no 1Password round trip (and no approval) per shell.
        export ANTHROPIC_AUTH_TOKEN="$(cat "$_token_cache")"
      elif token="$(op read 'op://Personal/DeepSeek API/credential' 2>/dev/null)"; then
        export ANTHROPIC_AUTH_TOKEN="$token"
        umask 077
        mkdir -p "$(dirname "$_token_cache")"
        printf '%s' "$token" > "$_token_cache"
      elif [[ -f "$_token_cache" ]]; then
        # Vault locked: fall back to the stale token instead of failing silently.
        export ANTHROPIC_AUTH_TOKEN="$(cat "$_token_cache")"
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
      ls = "eza --icons --group-directories-first";
    };
  };
}
