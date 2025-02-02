{ config, pkgs, lib, ... }:

{
  home.username = "al";
  home.homeDirectory = "/Users/al";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
    autojump
    vim_configurable
    git
    htop
    zsh
    zsh-fzf-tab
    direnv
    (python312.withPackages (ps: with ps; [ httpx requests ]))
  ];

  home.file = {
  };

  home.activation.installVundle = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=$PATH:${pkgs.git}/bin

    if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
      git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
    fi
  '';

  programs.home-manager.enable = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs.fzf = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.zsh = {
    initExtra = ''
      if command -v rg &> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files'
        export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --margin=1,4'
      fi
      eval "$(direnv hook zsh)"

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
    enable = true;
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "vi-mode" "autojump" ];
      theme = "onehalfdark";
      custom = "$HOME/.oh-my-zsh";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "OneHalfDark";
    };
  };

  programs.git = {
    enable = true;
    userName = "Anatoli Liotych";
    userEmail = "anatoli.liotych@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.file.".oh-my-zsh/themes/onehalfdark.zsh-theme".text = ''
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

  home.file.".vimrc".text = ''
  set nocompatible " be iMproved, required by Vundle too
  filetype off                  " required by Vundle
  set rtp+=~/.vim/bundle/Vundle.vim " set the runtime path to include Vundle
  call vundle#begin()
  Plugin 'gmarik/Vundle.vim'        " plugin manager
  Plugin 'tpope/vim-fugitive'       " git integration
  Plugin 'airblade/vim-gitgutter'   " shows git diff changes to the left
  Plugin 'bling/vim-airline'        " nice status line
  Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plugin 'junegunn/fzf.vim'
  Plugin 'gergap/vim-ollama'
  Plugin 'sonph/onehalf', { 'rtp': 'vim' }
  call vundle#end()            " required by Vundle

  filetype plugin indent on    " required by Vundle
  runtime macros/matchit.vim " smart way to show matching closing element pressing % on { shows } and so on
  " VIM Settings
  syntax on
  colorscheme onehalfdark
  let g:airline_theme='onehalfdark'
  set termguicolors
  highlight default link SignColumn LineNr
  set encoding=utf-8
  set timeoutlen=250                                             " used for mapping delays
  set fileformats+=mac                                           " uses special chars for OSX
  set relativenumber                                             " shows relative numbers
  set number                                                     " shows current line with relative numbers
  set path+=**                                                   " allows find to look deep into folders during search
  set wildmenu                                                   " lets you see what your other options for <TAB>
  set hidden                                                     " allows to manage multiple buffers effectively
  set incsearch                                                  " highligths search items dynamically as they are typed
  set ignorecase                                                 " the case of normal letters is ignored
  set smartcase                                                  " overrides ignorecase if search contains uppercase chars
  set nowrap                                                     " don't wrap lines
  set tabstop=2                                                  " tab to two spaces
  set shiftwidth=2                                               " identation in normal mode pressing < or >
  set softtabstop=2                                              " set 'tab' as 2 spaces and removes 2 spaces on backspace
  set expandtab                                                  " replaces tabs with spaces
  set smarttab                                                   " needed for tabbing
  set nofoldenable                                               " don't fold by default
  set ruler                                                      " shows the cursor position
  set laststatus=2                                               " shows status line
  set synmaxcol=200                                              " maximum column in which to search for syntax items.
  set autoindent                                                 " copy indent from current line when starting a new line
  set smartindent                                                " does smart autoindenting
  set nowritebackup                                              " to not write backup before save
  set autoread                                                   " to autoread if file was changed outside from vim
  set noswapfile                                                 " to not use swap files
  set nobackup                                                   " to not write backup during overwriting file
  set showcmd                                                    " shows command
  set list                                                       " enables showing of hidden chars
  set listchars=tab:▸\ ,eol:¬,trail:∙                            " shows hidden end of line. tabs and  trailing spaces
  set foldmethod=indent                                          " fold based on syntax
  set clipboard=unnamed                                          " copying from/to clipboard
  let g:tex_fast= ""
  " autoformating
  set nocursorline
  au FileType * setlocal formatoptions-=cro
  au BufWritePre * %s/\s\+$//e " removes trailing spaces
  au BufNewFile * set noeol                                      " removes eol
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+',-1) " highlights more than 80 symbols
  au BufNewFile,BufRead *.slim setf slim
  "
  " netrw settings
  let g:netrw_banner = 0       " removes banner
  let g:netrw_browse_split = 2 " opens file in vsplit
  let g:netrw_winsize = 40     " netrw winsize

  let g:ollama_chat_model = 'qwen2.5-coder:7b'
  let g:ollama_model = 'qwen2.5-coder:7b'
  "
  " fzf settings
  let g:fzf_layout = { 'window': { 'width': 0.99, 'height': 0.99 } }
  let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
  let $FZF_DEFAULT_COMMAND = 'rg --files --ignore-case --hidden -g "!{.git,node_modules,vendor}/*"'
  let $BAT_STYLE = 'header,numbers,grid'

  command! -bang -nargs=* -complete=dir Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --with-filename --no-heading --color=always --smart-case '
    \   .shellescape(<q-args>), 1, fzf#vim#with_preview({'options': ['--preview-window', '+{2}-5,~3']},
    \                                                   'right:75%', 'ctrl-/'), <bang>0)
  '';
}
