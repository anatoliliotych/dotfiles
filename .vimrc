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
set synmaxcol=200                                              " maximum column in which to search for syntax items.  In long lines the
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
au BufWritePre * %s/\s\+$//e " removes trailing spaces
au BufNewFile * set noeol                                      " removes eol
au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+',-1) " highlights more than 80 symbols
au BufNewFile,BufRead *.slim setf slim
"
" netrw settings
let g:netrw_banner = 0       " removes banner
let g:netrw_browse_split = 2 " opens file in vsplit
let g:netrw_winsize = 40     " netrw winsize
" ag settings
let g:ag_working_path_mode="r"
imap jj <Esc>

let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
let $FZF_DEFAULT_COMMAND = 'rg --files --ignore-case --hidden -g "!{.git,node_modules,vendor}/*"'
command! -bang -nargs=? -complete=dir Files
     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
