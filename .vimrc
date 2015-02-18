set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-commentary'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" VIM settings
" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
syntax on
set encoding=utf-8
set nowrap       " Don't wrap lines
set ignorecase
set fileformats+=mac
set list
set listchars=tab:▸\ ,eol:¬,trail:∙
set linebreak " wrap lines at convenient points
set nowritebackup
set autoread
set noswapfile
set nobackup
set showbreak=⇢\  " show wrapped lines
set laststatus=2 " always show status line
set ruler " show the cursor position all the time
set guioptions-=RLTrlt
colorscheme railscasts
set guifont=Meslo\ LG\ S\ for\ Powerline:h17
execute 'set colorcolumn=' . join(range(81,335), ',')
highlight default link SignColumn LineNr

set tabstop=2 " tab to two spaces
set foldmethod=indent   " fold based on indent
set foldnestmax=3       " deepest fold is 3 levels
set nofoldenable        " dont fold by default
set wildmode=list:longest
set wildmenu                " Enable ctrl-n and ctrl-p to scroll thru matches

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set expandtab

" Automatic formatting:
autocmd BufWritePre *.rb :%s/\s\+$//e
autocmd BufWritePre *.js :%s/\s\+$//e
autocmd BufWritePre *.haml :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e
autocmd BufWritePre *.scss :%s/\s\+$//e
autocmd BufNewFile * set noeol

" Airline config:
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#enabled=0

" NERDTree config:
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>c :NERDTree %<CR>
let NERDTreeMinimalUI  = 1
let NERDTreeShowHidden = 1
let g:NERDTreeWinSize  = 30  " Window size
let NERDTreeDirArrows  = 0   " No arrows, just | + and ~

" CtrlP config:
nmap <leader>p :CtrlP<CR>
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>P :CtrlP %:h<CR>
let g:ctrlp_mruf_relative = 1
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""' " use CtrlP for listing files
let g:ctrlp_use_caching = 0 " ag is fast enough, don't cache
let g:ctrlp_match_window = 'max:15'
let g:ctrlp_open_new_file = 'h' " open new file in a horizontal split

" Syntastic config:
let g:syntastic_check_on_open=1
