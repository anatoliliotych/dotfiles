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
