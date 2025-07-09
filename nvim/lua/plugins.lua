local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.expand('~/.config/nvim/plugged'))

Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ggml-org/llama.vim'
Plug 'ibhagwan/fzf-lua'
Plug('sonph/onehalf', { rtp = 'vim' })

vim.call('plug#end')
